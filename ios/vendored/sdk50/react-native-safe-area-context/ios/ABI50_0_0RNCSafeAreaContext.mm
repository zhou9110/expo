#import "ABI50_0_0RNCSafeAreaContext.h"

#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>
#import <UIKit/UIKit.h>
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <safeareacontext/safeareacontext.h>
#endif

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
using namespace ABI50_0_0facebook::ABI50_0_0React;

@interface ABI50_0_0RNCSafeAreaContext () <NativeSafeAreaContextSpec>
@end
#endif

@implementation ABI50_0_0RNCSafeAreaContext

ABI50_0_0RCT_EXPORT_MODULE()

+ (BOOL)requiresMainQueueSetup
{
  return YES;
}

- (NSDictionary *)constantsToExport
{
  return [self getConstants];
}

- (NSDictionary *)getConstants
{
  __block NSDictionary *constants;

  ABI50_0_0RCTUnsafeExecuteOnMainQueueSync(^{
    UIWindow *window = ABI50_0_0RCTKeyWindow();
    if (window == nil) {
      constants = @{@"initialWindowMetrics" : [NSNull null]};
      return;
    }

    UIEdgeInsets safeAreaInsets = window.safeAreaInsets;
    constants = @{
      @"initialWindowMetrics" : @{
        @"insets" : @{
          @"top" : @(safeAreaInsets.top),
          @"right" : @(safeAreaInsets.right),
          @"bottom" : @(safeAreaInsets.bottom),
          @"left" : @(safeAreaInsets.left),
        },
        @"frame" : @{
          @"x" : @(window.frame.origin.x),
          @"y" : @(window.frame.origin.y),
          @"width" : @(window.frame.size.width),
          @"height" : @(window.frame.size.height),
        },
      }
    };
  });

  return constants;
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED

- (std::shared_ptr<TurboModule>)getTurboModule:(const ObjCTurboModule::InitParams &)params
{
  return std::make_shared<NativeSafeAreaContextSpecJSI>(params);
}

#endif

@end
