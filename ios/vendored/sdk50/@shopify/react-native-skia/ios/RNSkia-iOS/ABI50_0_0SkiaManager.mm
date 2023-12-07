#import "ABI50_0_0SkiaManager.h"

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModule.h>

#import "ABI50_0_0RNSkiOSPlatformContext.h"

@implementation ABI50_0_0SkiaManager {
  std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkManager> _skManager;
  __weak ABI50_0_0RCTBridge *weakBridge;
}

- (std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkManager>)skManager {
  return _skManager;
}

- (void)invalidate {
  if (_skManager != nullptr) {
    _skManager->invalidate();
  }
  _skManager = nullptr;
}

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge {
  self = [super init];
  if (self) {
    ABI50_0_0RCTCxxBridge *cxxBridge = (ABI50_0_0RCTCxxBridge *)bridge;
    if (cxxBridge.runtime) {

      ABI50_0_0facebook::jsi::Runtime *jsRuntime =
          (ABI50_0_0facebook::jsi::Runtime *)cxxBridge.runtime;

      // Create the ABI50_0_0RNSkiaManager (cross platform)
      _skManager = std::make_shared<ABI50_0_0RNSkia::ABI50_0_0RNSkManager>(
          jsRuntime, bridge.jsCallInvoker,
          std::make_shared<ABI50_0_0RNSkia::ABI50_0_0RNSkiOSPlatformContext>(jsRuntime, bridge));
    }
  }
  return self;
}

@end
