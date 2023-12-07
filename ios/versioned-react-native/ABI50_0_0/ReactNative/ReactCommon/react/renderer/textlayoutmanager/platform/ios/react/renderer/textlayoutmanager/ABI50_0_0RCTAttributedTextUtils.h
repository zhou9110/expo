/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedString.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedStringBox.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0TextAttributes.h>

NS_ASSUME_NONNULL_BEGIN

NSString *const ABI50_0_0RCTAttributedStringIsHighlightedAttributeName = @"IsHighlighted";
NSString *const ABI50_0_0RCTAttributedStringEventEmitterKey = @"EventEmitter";

// String representation of either `role` or `accessibilityRole`
NSString *const ABI50_0_0RCTTextAttributesAccessibilityRoleAttributeName = @"AccessibilityRole";

/*
 * Creates `NSTextAttributes` from given `ABI50_0_0facebook::ABI50_0_0React::TextAttributes`
 */
NSDictionary<NSAttributedStringKey, id> *ABI50_0_0RCTNSTextAttributesFromTextAttributes(
    const ABI50_0_0facebook::ABI50_0_0React::TextAttributes &textAttributes);

/*
 * Conversions amond `NSAttributedString`, `AttributedString` and `AttributedStringBox`.
 */
NSAttributedString *ABI50_0_0RCTNSAttributedStringFromAttributedString(
    const ABI50_0_0facebook::ABI50_0_0React::AttributedString &attributedString);

NSAttributedString *ABI50_0_0RCTNSAttributedStringFromAttributedStringBox(
    const ABI50_0_0facebook::ABI50_0_0React::AttributedStringBox &attributedStringBox);

ABI50_0_0facebook::ABI50_0_0React::AttributedStringBox ABI50_0_0RCTAttributedStringBoxFromNSAttributedString(
    NSAttributedString *nsAttributedString);

NSString *ABI50_0_0RCTNSStringFromStringApplyingTextTransform(NSString *string, ABI50_0_0facebook::ABI50_0_0React::TextTransform textTransform);

@interface ABI50_0_0RCTWeakEventEmitterWrapper : NSObject
@property (nonatomic, assign) ABI50_0_0facebook::ABI50_0_0React::SharedEventEmitter eventEmitter;
@end

NS_ASSUME_NONNULL_END
