
#import "ABI50_0_0RNSkiaModule.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>

@implementation ABI50_0_0RNSkiaModule {
  ABI50_0_0SkiaManager *skiaManager;
}

ABI50_0_0RCT_EXPORT_MODULE()

#pragma Accessors

- (ABI50_0_0SkiaManager *)manager {
  return skiaManager;
}

#pragma Setup and invalidation

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (void)invalidate {
  if (skiaManager != nil) {
    [skiaManager invalidate];
  }
  skiaManager = nil;
}

ABI50_0_0RCT_EXPORT_BLOCKING_SYNCHRONOUS_METHOD(install) {
  if (skiaManager != nil) {
    // Already initialized, ignore call.
    return @true;
  }
  ABI50_0_0RCTBridge *bridge = [ABI50_0_0RCTBridge currentBridge];
  skiaManager = [[ABI50_0_0SkiaManager alloc] initWithBridge:bridge];
  return @true;
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:
    (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params {
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::NativeSkiaModuleSpecJSI>(params);
}
#endif

@end
