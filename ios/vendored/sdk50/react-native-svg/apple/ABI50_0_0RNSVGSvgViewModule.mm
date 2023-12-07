/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNSVGSvgViewModule.h"
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerUtils.h>
#import "ABI50_0_0RNSVGSvgView.h"

@implementation ABI50_0_0RNSVGSvgViewModule

ABI50_0_0RCT_EXPORT_MODULE()

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
@synthesize viewRegistry_DEPRECATED = _viewRegistry_DEPRECATED;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
@synthesize bridge = _bridge;

- (void)toDataURL:(nonnull NSNumber *)ABI50_0_0ReactTag
          options:(NSDictionary *)options
         callback:(ABI50_0_0RCTResponseSenderBlock)callback
          attempt:(int)attempt
{
  void (^block)(void) = ^{
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    [self.viewRegistry_DEPRECATED addUIBlock:^(ABI50_0_0RCTViewRegistry *viewRegistry) {
      __kindof ABI50_0_0RNSVGPlatformView *view = [viewRegistry viewForABI50_0_0ReactTag:ABI50_0_0ReactTag];
#else
    [self.bridge.uiManager
        addUIBlock:^(ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, ABI50_0_0RNSVGPlatformView *> *viewRegistry) {
          __kindof ABI50_0_0RNSVGPlatformView *view = [uiManager viewForABI50_0_0ReactTag:ABI50_0_0ReactTag];
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
      NSString *b64;
      if ([view isKindOfClass:[ABI50_0_0RNSVGSvgView class]]) {
        ABI50_0_0RNSVGSvgView *svg = view;
        if (options == nil) {
          b64 = [svg getDataURLWithBounds:svg.boundingBox];
        } else {
          id width = [options objectForKey:@"width"];
          id height = [options objectForKey:@"height"];
          if (![width isKindOfClass:NSNumber.class] || ![height isKindOfClass:NSNumber.class]) {
            ABI50_0_0RCTLogError(@"Invalid width or height given to toDataURL");
            return;
          }
          NSNumber *w = width;
          NSInteger wi = (NSInteger)[w intValue];
          NSNumber *h = height;
          NSInteger hi = (NSInteger)[h intValue];

          CGRect bounds = CGRectMake(0, 0, wi, hi);
          b64 = [svg getDataURLWithBounds:bounds];
        }
      } else {
        ABI50_0_0RCTLogError(@"Invalid svg returned from registry, expecting ABI50_0_0RNSVGSvgView, got: %@", view);
        return;
      }
      if (b64) {
        callback(@[ b64 ]);
      } else if (attempt < 1) {
        [self toDataURL:ABI50_0_0ReactTag options:options callback:callback attempt:(attempt + 1)];
      } else {
        callback(@[]);
      }
    }];
  };
  if (self.bridge) {
    dispatch_async(ABI50_0_0RCTGetUIManagerQueue(), block);
  } else {
    dispatch_async(dispatch_get_main_queue(), block);
  }
}

ABI50_0_0RCT_EXPORT_METHOD(toDataURL
                  : (nonnull NSNumber *)ABI50_0_0ReactTag options
                  : (NSDictionary *)options callback
                  : (ABI50_0_0RCTResponseSenderBlock)callback)
{
  [self toDataURL:ABI50_0_0ReactTag options:options callback:callback attempt:0];
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:
    (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::NativeSvgViewModuleSpecJSI>(params);
}
#endif

@end
