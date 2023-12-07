
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTViewComponentView.h>
#endif

#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import "ABI50_0_0RNSEnums.h"

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0RNSScreenStackHeaderSubview :
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
    ABI50_0_0RCTViewComponentView
#else
    UIView
#endif

@property (nonatomic) ABI50_0_0RNSScreenStackHeaderSubviewType type;

@property (nonatomic, weak) UIView *ABI50_0_0ReactSuperview;

@property (nonatomic, weak) ABI50_0_0RCTBridge *bridge;

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#else
- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@end

@interface ABI50_0_0RNSScreenStackHeaderSubviewManager : ABI50_0_0RCTViewManager

@property (nonatomic) ABI50_0_0RNSScreenStackHeaderSubviewType type;

@end

@interface ABI50_0_0RCTConvert (ABI50_0_0RNSScreenStackHeaderSubview)

+ (ABI50_0_0RNSScreenStackHeaderSubviewType)ABI50_0_0RNSScreenStackHeaderSubviewType:(id)json;

@end

NS_ASSUME_NONNULL_END
