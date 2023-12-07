#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0RCTOnPageSelected.h"

@implementation ABI50_0_0RCTOnPageSelected
{
    NSNumber* _position;
    uint16_t _coalescingKey;
}

@synthesize viewTag = _viewTag;

- (NSString *)eventName {
    return @"onPageSelected";
}

- (instancetype) initWithABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
                         position:(NSNumber *)position
                    coalescingKey:(uint16_t)coalescingKey;
{
    ABI50_0_0RCTAssertParam(ABI50_0_0ReactTag);
    
    if ((self = [super init])) {
        _viewTag = ABI50_0_0ReactTag;
        _position = position;
        _coalescingKey = coalescingKey;
    }
    return self;
}

ABI50_0_0RCT_NOT_IMPLEMENTED(- (instancetype)init)
- (uint16_t)coalescingKey
{
    return _coalescingKey;
}


- (BOOL)canCoalesce
{
    return NO;
}

+ (NSString *)moduleDotMethod
{
    return @"ABI50_0_0RCTEventEmitter.receiveEvent";
}

- (NSArray *)arguments
{
    return @[self.viewTag, ABI50_0_0RCTNormalizeInputEventName(self.eventName), @{
                 @"position": _position,
                 }];
}

- (id<ABI50_0_0RCTEvent>)coalesceWithEvent:(id<ABI50_0_0RCTEvent>)newEvent;
{
    return newEvent;
}

@end

