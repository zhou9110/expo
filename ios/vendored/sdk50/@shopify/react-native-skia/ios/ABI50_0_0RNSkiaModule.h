#pragma once

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <rnskia/rnskia.h>
#else
#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#endif

#include "ABI50_0_0SkiaManager.h"

@interface ABI50_0_0RNSkiaModule : NSObject
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
                          <NativeSkiaModuleSpec>
#else
                          <ABI50_0_0RCTBridgeModule>
#endif

- (ABI50_0_0SkiaManager *)manager;

@end
