#import <Foundation/Foundation.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0RCTOnPageScrollEvent : NSObject <ABI50_0_0RCTEvent>

- (instancetype) initWithABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
                         position:(NSNumber *)position
                           offset:(NSNumber *)offset;

@end

NS_ASSUME_NONNULL_END
