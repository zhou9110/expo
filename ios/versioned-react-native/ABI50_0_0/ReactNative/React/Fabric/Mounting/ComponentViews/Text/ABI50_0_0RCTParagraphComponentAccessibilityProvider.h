/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedString.h>
#import <ABI50_0_0React/renderer/attributedstring/ABI50_0_0ParagraphAttributes.h>
#import <ABI50_0_0React/renderer/textlayoutmanager/ABI50_0_0RCTTextLayoutManager.h>

#import "ABI50_0_0RCTParagraphComponentView.h"

@interface ABI50_0_0RCTParagraphComponentAccessibilityProvider : NSObject

- (instancetype)initWithString:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)attributedString
                 layoutManager:(ABI50_0_0RCTTextLayoutManager *)layoutManager
           paragraphAttributes:(ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                         frame:(CGRect)frame
                          view:(UIView *)view;

/*
 * Returns an array of `UIAccessibilityElement`s to be used for `UIAccessibilityContainer` implementation.
 */
- (NSArray<UIAccessibilityElement *> *)accessibilityElements;

/**
 @abstract To make sure the provider is up to date.
*/
- (BOOL)isUpToDate:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)currentAttributedString;

@end
