/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RNCPickerManager.h"
#import "ABI50_0_0RNCPicker.h"

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTFont.h>

@implementation ABI50_0_0RNCPickerManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [ABI50_0_0RNCPicker new];
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(items, NSArray<NSDictionary *>)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(selectedIndex, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(selectionColor, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onChange, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(color, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(textAlign, NSTextAlignment)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(numberOfLines, NSInteger)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(fontSize, NSNumber, ABI50_0_0RNCPicker)
{
  view.font = [ABI50_0_0RCTFont updateFont:view.font withSize:json ?: @(defaultView.font.pointSize)];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(fontWeight, NSString, __unused ABI50_0_0RNCPicker)
{
  view.font = [ABI50_0_0RCTFont updateFont:view.font withWeight:json]; // defaults to normal
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(fontStyle, NSString, __unused ABI50_0_0RNCPicker)
{
  view.font = [ABI50_0_0RCTFont updateFont:view.font withStyle:json]; // defaults to normal
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(fontFamily, NSString, ABI50_0_0RNCPicker)
{
  view.font = [ABI50_0_0RCTFont updateFont:view.font withFamily:json ?: defaultView.font.familyName];
}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(themeVariant, NSString, ABI50_0_0RNCPicker)
{
    if (@available(iOS 13.4, *)) {
            if (json) {
                if ([json isEqual:@"dark"])
                    view.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
                else if ([json isEqual:@"light"])
                    view.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
                else
                    view.overrideUserInterfaceStyle = UIUserInterfaceStyleUnspecified;
            }
        }
}

@end
