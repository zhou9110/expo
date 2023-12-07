#if TARGET_OS_OSX
#import <ABI50_0_0React/ABI50_0_0RCTTextView.h>
@interface ABI50_0_0RNSVGTopAlignedLabel : NSTextView

@property NSAttributedString *attributedText;
@property NSLineBreakMode lineBreakMode;
@property NSInteger numberOfLines;
@property NSString *text;
@property NSTextAlignment textAlignment;
#else
#import <UIKit/UIKit.h>
@interface ABI50_0_0RNSVGTopAlignedLabel : UILabel
#endif
@end
