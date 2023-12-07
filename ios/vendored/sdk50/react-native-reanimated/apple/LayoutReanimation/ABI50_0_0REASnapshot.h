#import <Foundation/Foundation.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0REASnapshot : NSObject

@property NSMutableDictionary *values;

- (instancetype)init:(ABI50_0_0REAUIView *)view;
- (instancetype)initWithAbsolutePosition:(ABI50_0_0REAUIView *)view;

@end

NS_ASSUME_NONNULL_END
