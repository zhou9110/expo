#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0RCTOnPageScrollEvent.h"

@implementation ABI50_0_0RCTOnPageScrollEvent
{
    NSNumber* _position;
    NSNumber* _offset;
}

@synthesize viewTag = _viewTag;

- (NSString *)eventName {
    return @"onPageScroll";
}

- (instancetype) initWithABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
                         position:(NSNumber *)position
                           offset:(NSNumber *)offset;
{
    ABI50_0_0RCTAssertParam(ABI50_0_0ReactTag);
    
    if ((self = [super init])) {
        _viewTag = ABI50_0_0ReactTag;
        _position = position;
        _offset = offset;
    }
    return self;
}

ABI50_0_0RCT_NOT_IMPLEMENTED(- (instancetype)init)
- (uint16_t)coalescingKey
{
    return 0;
}


- (BOOL)canCoalesce
{
    return YES;
}

+ (NSString *)moduleDotMethod
{
    return @"ABI50_0_0RCTEventEmitter.receiveEvent";
}

- (NSArray *)arguments
{
    return @[self.viewTag, ABI50_0_0RCTNormalizeInputEventName(self.eventName), @{
                 @"position": _position,
                 @"offset": _offset
                 }];
}

- (id<ABI50_0_0RCTEvent>)coalesceWithEvent:(id<ABI50_0_0RCTEvent>)newEvent;
{
    return newEvent;
}

@end
