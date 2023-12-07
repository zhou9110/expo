#pragma once

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#include "SkImage.h"

#pragma clang diagnostic pop

@interface ABI50_0_0ViewScreenshotService : NSObject {
}

- (instancetype)initWithUiManager:(ABI50_0_0RCTUIManager *)uiManager;
- (sk_sp<SkImage>)screenshotOfViewWithTag:(NSNumber *)viewTag;

@end
