// Copyright 2017-present 650 Industries. All rights reserved.

#import <AVFoundation/AVFoundation.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXUIManager.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXEventEmitterService.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXAppLifecycleService.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXFileSystemInterface.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsInterface.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXPermissionsMethodsDelegate.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXJavaScriptContextProvider.h>

#import <ABI50_0_0EXAV/ABI50_0_0EXAV.h>
#import <ABI50_0_0EXAV/ABI50_0_0EXAVPlayerData.h>
#import <ABI50_0_0EXAV/ABI50_0_0EXVideoView.h>
#import <ABI50_0_0EXAV/ABI50_0_0EXAV+AudioSampleCallback.h>

NSString *const ABI50_0_0EXDidUpdatePlaybackStatusEventName = @"didUpdatePlaybackStatus";

NSString *const ABI50_0_0EXDidUpdateMetadataEventName = @"didUpdateMetadata";

@interface ABI50_0_0EXAV ()

@property (nonatomic, weak) ABI50_0_0RCTBridge *bridge;

@property (nonatomic, weak) id kernelAudioSessionManagerDelegate;
@property (nonatomic, weak) id kernelPermissionsServiceDelegate;

@property (nonatomic, assign) BOOL audioIsEnabled;
@property (nonatomic, assign) ABI50_0_0EXAVAudioSessionMode currentAudioSessionMode;
@property (nonatomic, assign) BOOL isBackgrounded;

@property (nonatomic, assign) ABI50_0_0EXAudioInterruptionMode audioInterruptionMode;
@property (nonatomic, assign) BOOL playsInSilentMode;
@property (nonatomic, assign) BOOL staysActiveInBackground;

@property (nonatomic, assign) int soundDictionaryKeyCount;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, ABI50_0_0EXAVPlayerData *> *soundDictionary;
@property (nonatomic, assign) BOOL isBeingObserved;
@property (nonatomic, strong) NSHashTable <NSObject<ABI50_0_0EXAVObject> *> *videoSet;

@property (nonatomic, weak) ABI50_0_0EXModuleRegistry *expoModuleRegistry;

@end

@implementation ABI50_0_0EXAV

ABI50_0_0EX_EXPORT_MODULE(ExponentAV);

- (instancetype)init
{
  if (self = [super init]) {
    _audioIsEnabled = YES;
    _currentAudioSessionMode = ABI50_0_0EXAVAudioSessionModeInactive;
    _isBackgrounded = NO;

    _audioInterruptionMode = ABI50_0_0EXAudioInterruptionModeMixWithOthers;
    _playsInSilentMode = false;
    _staysActiveInBackground = false;

    _soundDictionaryKeyCount = 0;
    _soundDictionary = [NSMutableDictionary new];
    _isBeingObserved = NO;
    _videoSet = [NSHashTable weakObjectsHashTable];
  }
  return self;
}

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI50_0_0EXAVInterface)];
}

- (void)installJsiBindings
{
  id<ABI50_0_0EXJavaScriptContextProvider> jsContextProvider = [_expoModuleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXJavaScriptContextProvider)];
  void *jsRuntimePtr = [jsContextProvider javaScriptRuntimePointer];
  if (jsRuntimePtr) {
    [self installJSIBindingsForRuntime:jsRuntimePtr withSoundDictionary:_soundDictionary];
  }
}

- (NSDictionary *)constantsToExport
{
  // install JSI bindings here because `constantsToExport` is called when the JS runtime has been created
  [self installJsiBindings];

  return @{
    @"Qualities": @{
        @"Low": AVAudioTimePitchAlgorithmLowQualityZeroLatency,
        @"Medium": AVAudioTimePitchAlgorithmTimeDomain,
        @"High": AVAudioTimePitchAlgorithmSpectral
    }
  };
}

#pragma mark - Expo experience lifecycle

- (void)setModuleRegistry:(ABI50_0_0EXModuleRegistry *)expoModuleRegistry
{
  [[_expoModuleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXAppLifecycleService)] unregisterAppLifecycleListener:self];
  _expoModuleRegistry = expoModuleRegistry;
  _kernelAudioSessionManagerDelegate = [_expoModuleRegistry getSingletonModuleForName:@"AudioSessionManager"];
  if (!_isBackgrounded) {
    [_kernelAudioSessionManagerDelegate moduleDidForeground:self];
  }
  [[_expoModuleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXAppLifecycleService)] registerAppLifecycleListener:self];
}

- (void)onAppForegrounded
{
  [_kernelAudioSessionManagerDelegate moduleDidForeground:self];
  _isBackgrounded = NO;

  [self _runBlockForAllAVObjects:^(NSObject<ABI50_0_0EXAVObject> *exAVObject) {
    [exAVObject appDidForeground];
  }];
}

- (void)onAppBackgrounded
{
  _isBackgrounded = YES;
  if (!_staysActiveInBackground) {
    [self _deactivateAudioSession]; // This will pause all players and stop all recordings

    [self _runBlockForAllAVObjects:^(NSObject<ABI50_0_0EXAVObject> *exAVObject) {
      [exAVObject appDidBackgroundStayActive:NO];
    }];
    [_kernelAudioSessionManagerDelegate moduleDidBackground:self];
  } else {
    [self _runBlockForAllAVObjects:^(NSObject<ABI50_0_0EXAVObject> *exAVObject) {
      [exAVObject appDidBackgroundStayActive:YES];
    }];
  }
}

- (void)onAppContentWillReload
{
  // We need to clear audio tap before sound gets destroyed to avoid
  // using pointer to deallocated ABI50_0_0EXAVPlayerData in MTAudioTap process callback
  for (NSNumber *key in [_soundDictionary allKeys]) {
    [self _removeAudioCallbackForKey:key];
  }
}

#pragma mark - ABI50_0_0RCTBridgeModule

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge
{
  _bridge = bridge;
}

// Required in Expo Go only - ABI50_0_0EXAV conforms to ABI50_0_0RCTBridgeModule protocol
// and in Expo Go, kernel calls [ABI50_0_0EXReactAppManager rebuildBridge]
// which requires this to be implemented. Normal "bare" RN modules
// use ABI50_0_0RCT_EXPORT_MODULE macro which implement this automatically.
+(NSString *)moduleName
{
  return @"ExponentAV";
}

// Both ABI50_0_0RCTBridgeModule and ABI50_0_0EXExportedModule define `constantsToExport`. We implement
// that method for the latter, but ABI50_0_0React Bridge displays a yellow LogBox warning:
// "Module ABI50_0_0EXAV requires main queue setup since it overrides `constantsToExport` but doesn't implement `requiresMainQueueSetup`."
// Since we don't care about that (ABI50_0_0RCTBridgeModule is used here for another reason),
// we just need this to dismiss that warning.
+ (BOOL)requiresMainQueueSetup
{
  // We are now using main thread to avoid thread safety issues with `ABI50_0_0EXAVPlayerData` and `ABI50_0_0EXVideoView`
  // return `YES` to avoid deadlock warnings.
  return YES;
}

#pragma mark - ABI50_0_0RCTEventEmitter

- (void)startObserving
{
  _isBeingObserved = YES;
}

- (void)stopObserving
{
  _isBeingObserved = NO;
}

#pragma mark - Global audio state control API

- (void)registerVideoForAudioLifecycle:(NSObject<ABI50_0_0EXAVObject> *)video
{
  [_videoSet addObject:video];
}

- (void)unregisterVideoForAudioLifecycle:(NSObject<ABI50_0_0EXAVObject> *)video
{
  [_videoSet removeObject:video];
}

- (void)_runBlockForAllAVObjects:(void (^)(NSObject<ABI50_0_0EXAVObject> *exAVObject))block
{
  for (ABI50_0_0EXAVPlayerData *data in [_soundDictionary allValues]) {
    block(data);
  }
  for (NSObject<ABI50_0_0EXAVObject> *video in [_videoSet allObjects]) {
    block(video);
  }
}

// This method is placed here so that it is easily referrable from _setAudioSessionCategoryForAudioMode.
- (NSError *)_setAudioMode:(NSDictionary *)mode
{
  BOOL playsInSilentMode = ((NSNumber *)mode[@"playsInSilentModeIOS"]).boolValue;
  ABI50_0_0EXAudioInterruptionMode interruptionMode = ((NSNumber *)mode[@"interruptionModeIOS"]).intValue;
  BOOL shouldPlayInBackground = ((NSNumber *)mode[@"staysActiveInBackground"]).boolValue;

  if (!playsInSilentMode && interruptionMode == ABI50_0_0EXAudioInterruptionModeDuckOthers) {
    return ABI50_0_0EXErrorWithMessage(@"Impossible audio mode: playsInSilentMode == false and duckOthers == true cannot be set on iOS.");
  } else if (!playsInSilentMode && shouldPlayInBackground) {
    return ABI50_0_0EXErrorWithMessage(@"Impossible audio mode: playsInSilentMode == false and staysActiveInBackground == true cannot be set on iOS.");
  } else {
    _playsInSilentMode = playsInSilentMode;
    _audioInterruptionMode = interruptionMode;
    _staysActiveInBackground = shouldPlayInBackground;

    if (_currentAudioSessionMode != ABI50_0_0EXAVAudioSessionModeInactive) {
      return [self _updateAudioSessionCategoryForAudioSessionMode:[self _getAudioSessionModeRequired]];
    }
    return nil;
  }
}

- (NSError *)_updateAudioSessionCategoryForAudioSessionMode:(ABI50_0_0EXAVAudioSessionMode)audioSessionMode
{
  AVAudioSessionCategory requiredAudioCategory;
  AVAudioSessionCategoryOptions requiredAudioCategoryOptions = 0;

  if (!_playsInSilentMode) {
    // _allowsRecording is guaranteed to be false, and _interruptionMode is guaranteed to not be ABI50_0_0EXAudioInterruptionModeDuckOthers (see above)
    if (_audioInterruptionMode == ABI50_0_0EXAudioInterruptionModeDoNotMix) {
      requiredAudioCategory = AVAudioSessionCategorySoloAmbient;
    } else {
      requiredAudioCategory = AVAudioSessionCategoryAmbient;
    }
  } else {
    ABI50_0_0EXAudioInterruptionMode activeInterruptionMode = audioSessionMode == ABI50_0_0EXAVAudioSessionModeActiveMuted ? ABI50_0_0EXAudioInterruptionModeMixWithOthers : _audioInterruptionMode;
    NSString *category = AVAudioSessionCategoryPlayback;
    requiredAudioCategory = category;
    switch (activeInterruptionMode) {
      case ABI50_0_0EXAudioInterruptionModeDoNotMix:
        break;
      case ABI50_0_0EXAudioInterruptionModeDuckOthers:
        requiredAudioCategoryOptions = AVAudioSessionCategoryOptionDuckOthers;
        break;
      case ABI50_0_0EXAudioInterruptionModeMixWithOthers:
      default:
        requiredAudioCategoryOptions = AVAudioSessionCategoryOptionMixWithOthers;
        break;
    }
  }

  if ([[_kernelAudioSessionManagerDelegate activeCategory] isEqual:requiredAudioCategory] && [_kernelAudioSessionManagerDelegate activeCategoryOptions] == requiredAudioCategoryOptions) {
    return nil;
  }

  return [_kernelAudioSessionManagerDelegate setCategory:requiredAudioCategory withOptions:requiredAudioCategoryOptions forModule:self];
}

- (ABI50_0_0EXAVAudioSessionMode)_getAudioSessionModeRequired
{
  __block ABI50_0_0EXAVAudioSessionMode audioSessionModeRequired = ABI50_0_0EXAVAudioSessionModeInactive;

  [self _runBlockForAllAVObjects:^(NSObject<ABI50_0_0EXAVObject> *exAVObject) {
    ABI50_0_0EXAVAudioSessionMode audioSessionModeRequiredByThisObject = [exAVObject getAudioSessionModeRequired];
    if (audioSessionModeRequiredByThisObject > audioSessionModeRequired) {
      audioSessionModeRequired = audioSessionModeRequiredByThisObject;
    }
  }];

  return audioSessionModeRequired;
}

- (NSError *)promoteAudioSessionIfNecessary
{
  if (!_audioIsEnabled) {
    return ABI50_0_0EXErrorWithMessage(@"Expo Audio is disabled, so the audio session could not be activated.");
  }
  if (_isBackgrounded && !_staysActiveInBackground && ![_kernelAudioSessionManagerDelegate isActiveForModule:self]) {
    return ABI50_0_0EXErrorWithMessage(@"This experience is currently in the background, so the audio session could not be activated.");
  }

  ABI50_0_0EXAVAudioSessionMode audioSessionModeRequired = [self _getAudioSessionModeRequired];

  if (audioSessionModeRequired == ABI50_0_0EXAVAudioSessionModeInactive) {
    return nil;
  }

  NSError *error;

  error = [self _updateAudioSessionCategoryForAudioSessionMode:audioSessionModeRequired];
  if (error) {
    return error;
  }

  error = [_kernelAudioSessionManagerDelegate setActive:YES forModule:self];
  if (error) {
    return error;
  }

  _currentAudioSessionMode = audioSessionModeRequired;
  return nil;
}

- (NSError *)_deactivateAudioSession
{
  if (_currentAudioSessionMode == ABI50_0_0EXAVAudioSessionModeInactive) {
    return nil;
  }

  // We must have all players, recorders, and videos paused in order to effectively deactivate the session.
  [self _runBlockForAllAVObjects:^(NSObject<ABI50_0_0EXAVObject> *exAVObject) {
    [exAVObject pauseImmediately];
  }];

  NSError *error = [_kernelAudioSessionManagerDelegate setActive:NO forModule:self];

  if (!error) {
    _currentAudioSessionMode = ABI50_0_0EXAVAudioSessionModeInactive;
  }
  return error;
}

- (NSError *)demoteAudioSessionIfPossible
{
  ABI50_0_0EXAVAudioSessionMode audioSessionModeRequired = [self _getAudioSessionModeRequired];

  // Current audio session mode is lower than the required one
  // (we should rather promote the session than demote it).
  if (_currentAudioSessionMode <= audioSessionModeRequired) {
    return nil;
  }

  // We require the session to be muted and it is active.
  // Let's only update the category.
  if (audioSessionModeRequired == ABI50_0_0EXAVAudioSessionModeActiveMuted) {
    NSError *error = [self _updateAudioSessionCategoryForAudioSessionMode:audioSessionModeRequired];
    if (!error) {
      _currentAudioSessionMode = ABI50_0_0EXAVAudioSessionModeActiveMuted;
    }
    return error;
  }

  // We require the session to be inactive and it is active, let's deactivate it!
  return [self _deactivateAudioSession];
}

- (void)handleAudioSessionInterruption:(NSNotification *)notification
{
  NSNumber *interruptionType = [[notification userInfo] objectForKey:AVAudioSessionInterruptionTypeKey];
  if (interruptionType.unsignedIntegerValue == AVAudioSessionInterruptionTypeBegan) {
    _currentAudioSessionMode = ABI50_0_0EXAVAudioSessionModeInactive;
  }

  [self _runBlockForAllAVObjects:^(NSObject<ABI50_0_0EXAVObject> *exAVObject) {
    [exAVObject handleAudioSessionInterruption:notification];
  }];
}

- (void)handleMediaServicesReset:(NSNotification *)notification
{
  // See here: https://developer.apple.com/library/content/qa/qa1749/_index.html
  // (this is an unlikely notification to receive, but best practices suggests that we catch it just in case)
}

#pragma mark - Internal sound playback helper methods

- (void)_runBlock:(void (^)(ABI50_0_0EXAVPlayerData *data))block
  withSoundForKey:(nonnull NSNumber *)key
     withRejecter:(ABI50_0_0EXPromiseRejectBlock)reject
{
  ABI50_0_0EXAVPlayerData *data = _soundDictionary[key];
  if (data) {
    block(data);
  } else {
    reject(@"E_AUDIO_NOPLAYER", @"Sound object not loaded. Did you unload it using Audio.unloadAsync?", nil);
  }
}

- (void)_removeSoundForKey:(NSNumber *)key
{
  ABI50_0_0EXAVPlayerData *data = _soundDictionary[key];
  if (data) {
    [data pauseImmediately];
    _soundDictionary[key] = nil;
    [self demoteAudioSessionIfPossible];
  }
}

- (void)_removeAudioCallbackForKey:(NSNumber *)key
{
  ABI50_0_0EXAVPlayerData *data = _soundDictionary[key];
  if (data) {
    [data setSampleBufferCallback:nil];
  }
}

#pragma mark - Internal video playback helper method

- (void)_runBlock:(void (^)(ABI50_0_0EXVideoView *view))block
withEXVideoViewForTag:(nonnull NSNumber *)reactTag
     withRejecter:(ABI50_0_0EXPromiseRejectBlock)reject
{
  // TODO check that the bridge is still valid after the dispatch
  // TODO check if the queues are ok
  [[_expoModuleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXUIManager)] executeUIBlock:^(id view) {
    if ([view isKindOfClass:[ABI50_0_0EXVideoView class]]) {
      block(view);
    } else {
      reject(@"E_VIDEO_TAGINCORRECT", [NSString stringWithFormat:@"Invalid view returned from registry, expecting ABI50_0_0EXVideo, got: %@", view], nil);
    }
  } forView:reactTag ofClass:[ABI50_0_0EXVideoView class]];
}

#pragma mark - Internal audio recording helper methods

- (NSString *)_getBitRateStrategyFromEnum:(NSNumber *)bitRateEnumSelected
{
  if (bitRateEnumSelected) {
    switch ([bitRateEnumSelected integerValue]) {
      case ABI50_0_0EXAudioRecordingOptionBitRateStrategyConstant:
        return AVAudioBitRateStrategy_Constant;
      case ABI50_0_0EXAudioRecordingOptionBitRateStrategyLongTermAverage:
        return AVAudioBitRateStrategy_LongTermAverage;
      case ABI50_0_0EXAudioRecordingOptionBitRateStrategyVariableConstrained:
        return AVAudioBitRateStrategy_VariableConstrained;
        break;
      case ABI50_0_0EXAudioRecordingOptionBitRateStrategyVariable:
        return AVAudioBitRateStrategy_Variable;
      default:
        return nil;
    }
  }
  return nil;
}

- (NSDictionary<NSString *, NSString *> *)_getAVKeysForRecordingOptionsKeys:(NSString *)bitRateStrategy
{
  return @{};
}

- (UInt32)_getFormatIDFromString:(NSString *)typeString
{
  const char *s = typeString.UTF8String;
  UInt32 typeCode = s[3] | (s[2] << 8) | (s[1] << 16) | (s[0] << 24);
  return typeCode;
}

- (NSArray<NSString *> *)supportedEvents
{
  return @[ABI50_0_0EXDidUpdatePlaybackStatusEventName, ABI50_0_0EXDidUpdateMetadataEventName, @"ExponentAV.onError"];
}

#pragma mark - Audio API: Global settings

ABI50_0_0EX_EXPORT_METHOD_AS(setAudioIsEnabled,
                    setAudioIsEnabled:(BOOL)value
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  _audioIsEnabled = value;

  if (!value) {
    [self _deactivateAudioSession];
  }
  resolve(nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(setAudioMode,
                    setAudioMode:(NSDictionary *)mode
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  NSError *error = [self _setAudioMode:mode];

  if (error) {
    reject(@"E_AUDIO_AUDIOMODE", nil, error);
  } else {
    resolve(nil);
  }
}

#pragma mark - Unified playback API - Audio

ABI50_0_0EX_EXPORT_METHOD_AS(loadForSound,
                    loadForSound:(NSDictionary *)source
                    withStatus:(NSDictionary *)status
                    resolver:(ABI50_0_0EXPromiseResolveBlock)loadSuccess
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)loadError)
{
  NSNumber *key = @(_soundDictionaryKeyCount++);

  ABI50_0_0EX_WEAKIFY(self);
  ABI50_0_0EXAVPlayerData *data = [[ABI50_0_0EXAVPlayerData alloc] initWithEXAV:self
                                                   withSource:source
                                                   withStatus:status
                                          withLoadFinishBlock:^(BOOL success, NSDictionary *successStatus, NSString *error) {
    ABI50_0_0EX_ENSURE_STRONGIFY(self);
    if (success) {
      loadSuccess(@[key, successStatus]);
    } else {
      [self _removeSoundForKey:key];
      loadError(@"ABI50_0_0EXAV", error, nil);
    }
  }];
  data.errorCallback = ^(NSString *error) {
    ABI50_0_0EX_ENSURE_STRONGIFY(self);
    [self sendEventWithName:@"ExponentAV.onError" body:@{
      @"key": key,
      @"error": error
    }];
    [self _removeSoundForKey:key];
  };

  data.statusUpdateCallback = ^(NSDictionary *status) {
    ABI50_0_0EX_ENSURE_STRONGIFY(self);
    if (self.isBeingObserved) {
      NSDictionary<NSString *, id> *response = @{@"key": key, @"status": status};
      [self sendEventWithName:ABI50_0_0EXDidUpdatePlaybackStatusEventName body:response];
    }
  };

  data.metadataUpdateCallback = ^(NSDictionary *metadata) {
    ABI50_0_0EX_ENSURE_STRONGIFY(self);
      if (self.isBeingObserved) {
        NSDictionary<NSString *, id> *response = @{@"key": key, @"metadata": metadata};
        [self sendEventWithName:ABI50_0_0EXDidUpdateMetadataEventName body:response];
      }
  };

  _soundDictionary[key] = data;
}

- (void)sendEventWithName:(NSString *)eventName body:(NSDictionary *)body
{
  [[_expoModuleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXEventEmitterService)] sendEventWithName:eventName body:body];
}

ABI50_0_0EX_EXPORT_METHOD_AS(unloadForSound,
                    unloadForSound:(NSNumber *)key
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXAVPlayerData *data) {
    [self _removeSoundForKey:key];
    resolve([ABI50_0_0EXAVPlayerData getUnloadedStatus]);
  } withSoundForKey:key withRejecter:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(setStatusForSound,
                    setStatusForSound:(NSNumber *)key
                    withStatus:(NSDictionary *)status
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXAVPlayerData *data) {
    [data setStatus:status
           resolver:resolve
           rejecter:reject];
  } withSoundForKey:key withRejecter:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(getStatusForSound,
                    getStatusForSound:(NSNumber *)key
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXAVPlayerData *data) {
    NSDictionary *status = [data getStatus];
    resolve(status);
  } withSoundForKey:key withRejecter:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(replaySound,
                    replaySound:(NSNumber *)key
                    withStatus:(NSDictionary *)status
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXAVPlayerData *data) {
    [data replayWithStatus:status
                  resolver:resolve
                  rejecter:reject];
  } withSoundForKey:key withRejecter:reject];
}

#pragma mark - Unified playback API - Video

ABI50_0_0EX_EXPORT_METHOD_AS(loadForVideo,
                    loadForVideo:(NSNumber *)reactTag
                    source:(NSDictionary *)source
                    withStatus:(NSDictionary *)status
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXVideoView *view) {
    [view setSource:source withStatus:status resolver:resolve rejecter:reject];
  } withEXVideoViewForTag:reactTag withRejecter:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(unloadForVideo,
                    unloadForVideo:(NSNumber *)reactTag
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXVideoView *view) {
    [view setSource:nil withStatus:nil resolver:resolve rejecter:reject];
  } withEXVideoViewForTag:reactTag withRejecter:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(setStatusForVideo,
                    setStatusForVideo:(NSNumber *)reactTag
                    withStatus:(NSDictionary *)status
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXVideoView *view) {
    [view setStatusFromPlaybackAPI:status resolver:resolve rejecter:reject];
  } withEXVideoViewForTag:reactTag withRejecter:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(replayVideo,
                    replayVideo:(NSNumber *)reactTag
                    withStatus:(NSDictionary *)status
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXVideoView *view) {
    [view replayWithStatus:status resolver:resolve rejecter:reject];
  } withEXVideoViewForTag:reactTag withRejecter:reject];
}

ABI50_0_0EX_EXPORT_METHOD_AS(getStatusForVideo,
                    getStatusForVideo:(NSNumber *)reactTag
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  [self _runBlock:^(ABI50_0_0EXVideoView *view) {
    resolve(view.status);
  } withEXVideoViewForTag:reactTag withRejecter:reject];
}

// Note that setStatusUpdateCallback happens in the JS for video via onStatusUpdate

#pragma mark - Audio API: Recording

ABI50_0_0EX_EXPORT_METHOD_AS(getPermissionsAsync,
                    getPermissionsAsync:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(requestPermissionsAsync,
                    requestPermissionsAsync:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(prepareAudioRecorder,
                    prepareAudioRecorder:(NSDictionary *)options
                    resolver:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(startAudioRecording,
                    startAudioRecording:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(pauseAudioRecording,
                    pauseAudioRecording:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(stopAudioRecording,
                    stopAudioRecording:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(getAudioRecordingStatus,
                    getAudioRecordingStatus:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(unloadAudioRecorder,
                    unloadAudioRecorder:(ABI50_0_0EXPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0EXPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(getAvailableInputs,
                    resolver:(ABI50_0_0UMPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0UMPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(getCurrentInput,
                    getCurrentInput:(ABI50_0_0UMPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0UMPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

ABI50_0_0EX_EXPORT_METHOD_AS(setInput,
                    setInput:(NSString*)input
                    resolver:(ABI50_0_0UMPromiseResolveBlock)resolve
                    rejecter:(ABI50_0_0UMPromiseRejectBlock)reject)
{
  reject(@"E_UNSUPPORTED_PLATFORM", @"Not available on TV.", nil);
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

#pragma mark - Lifecycle

- (void)dealloc
{
  [_kernelAudioSessionManagerDelegate moduleWillDeallocate:self];
  [[_expoModuleRegistry getModuleImplementingProtocol:@protocol(ABI50_0_0EXAppLifecycleService)] unregisterAppLifecycleListener:self];
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  // This will clear all @properties and deactivate the audio session:

  for (NSObject<ABI50_0_0EXAVObject> *video in [_videoSet allObjects]) {
    [video pauseImmediately];
    [_videoSet removeObject:video];
  }
  for (NSNumber *key in [_soundDictionary allKeys]) {
    [self _removeSoundForKey:key];
  }
}

@end
