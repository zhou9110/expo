#pragma once

#import <memory>
#import <string>

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#import <ABI50_0_0RNSkManager.h>
#import <ABI50_0_0RNSkiOSView.h>
#import <ABI50_0_0SkiaManager.h>

#if ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

class ABI50_0_0RNSkiOSJsView;

@interface ABI50_0_0SkiaUIView :
#if ABI50_0_0RCT_NEW_ARCH_ENABLED
    ABI50_0_0RCTViewComponentView
#else
    UIView
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (instancetype)
    initWithManager:(ABI50_0_0RNSkia::ABI50_0_0RNSkManager *)manager
            factory:(std::function<std::shared_ptr<ABI50_0_0RNSkBaseiOSView>(
                         std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext>)>)factory;
- (void)initCommon:(ABI50_0_0RNSkia::ABI50_0_0RNSkManager *)manager
           factory:(std::function<std::shared_ptr<ABI50_0_0RNSkBaseiOSView>(
                        std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext>)>)factory;
- (std::shared_ptr<ABI50_0_0RNSkBaseiOSView>)impl;
- (ABI50_0_0SkiaManager *)skiaManager;

- (void)setDrawingMode:(std::string)mode;
- (void)setDebugMode:(bool)debugMode;
- (void)setNativeId:(size_t)nativeId;

@end
