/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedString.h>
#import <ABI50_0_0React/renderer/attributedstring/ABI50_0_0ParagraphAttributes.h>
#import <ABI50_0_0React/renderer/core/ABI50_0_0LayoutConstraints.h>
#import <ABI50_0_0React/renderer/textlayoutmanager/ABI50_0_0TextMeasureCache.h>

NS_ASSUME_NONNULL_BEGIN

/**
 @abstract Enumeration block for text fragments.
*/

using ABI50_0_0RCTTextLayoutFragmentEnumerationBlock =
    void (^)(CGRect fragmentRect, NSString *_Nonnull fragmentText, NSString *value);

/**
 * iOS-specific TextLayoutManager
 */
@interface ABI50_0_0RCTTextLayoutManager : NSObject

- (ABI50_0_0facebook::ABI50_0_0React::TextMeasurement)measureAttributedString:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)attributedString
                                        paragraphAttributes:(ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                                          layoutConstraints:(ABI50_0_0facebook::ABI50_0_0React::LayoutConstraints)layoutConstraints
                                                textStorage:(NSTextStorage *_Nullable)textStorage;

- (ABI50_0_0facebook::ABI50_0_0React::TextMeasurement)measureNSAttributedString:(NSAttributedString *)attributedString
                                          paragraphAttributes:(ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                                            layoutConstraints:(ABI50_0_0facebook::ABI50_0_0React::LayoutConstraints)layoutConstraints
                                                  textStorage:(NSTextStorage *_Nullable)textStorage;

- (NSTextStorage *)textStorageForAttributesString:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)attributedString
                              paragraphAttributes:(ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                                             size:(CGSize)size;

- (void)drawAttributedString:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)attributedString
         paragraphAttributes:(ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                       frame:(CGRect)frame
                 textStorage:(NSTextStorage *_Nullable)textStorage;

- (ABI50_0_0facebook::ABI50_0_0React::LinesMeasurements)getLinesForAttributedString:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)attributedString
                                              paragraphAttributes:
                                                  (ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                                                             size:(CGSize)size;

- (ABI50_0_0facebook::ABI50_0_0React::SharedEventEmitter)
    getEventEmitterWithAttributeString:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)attributedString
                   paragraphAttributes:(ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                                 frame:(CGRect)frame
                               atPoint:(CGPoint)point;

- (void)getRectWithAttributedString:(ABI50_0_0facebook::ABI50_0_0React::AttributedString)attributedString
                paragraphAttributes:(ABI50_0_0facebook::ABI50_0_0React::ParagraphAttributes)paragraphAttributes
                 enumerateAttribute:(NSString *)enumerateAttribute
                              frame:(CGRect)frame
                         usingBlock:(ABI50_0_0RCTTextLayoutFragmentEnumerationBlock)block;

@end

NS_ASSUME_NONNULL_END
