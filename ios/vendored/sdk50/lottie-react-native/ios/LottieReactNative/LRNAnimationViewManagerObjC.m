#import <ABI50_0_0React/ABI50_0_0RCTViewManager.h>
#import "ABI50_0_0RCTConvert+Lottie.h"

@interface ABI50_0_0RCT_EXTERN_REMAP_MODULE(LottieAnimationView, ABI50_0_0LottieAnimationView, ABI50_0_0RCTViewManager)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(resizeMode, NSString);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(sourceJson, NSString);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(sourceName, NSString);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(sourceURL, NSString);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(sourceDotLottieURI, NSString);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(progress, CGFloat);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(loop, BOOL);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(autoPlay, BOOL);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(speed, CGFloat);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onAnimationFinish, ABI50_0_0RCTBubblingEventBlock);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onAnimationFailure, ABI50_0_0RCTBubblingEventBlock);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onAnimationLoaded, ABI50_0_0RCTBubblingEventBlock);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(colorFilters, LRNColorFilters);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(textFiltersIOS, NSArray);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(renderMode, NSString);

ABI50_0_0RCT_EXTERN_METHOD(play:(nonnull NSNumber *)ABI50_0_0ReactTag fromFrame:(nonnull NSNumber *) startFrame toFrame:(nonnull NSNumber *) endFrame);

ABI50_0_0RCT_EXTERN_METHOD(reset:(nonnull NSNumber *)ABI50_0_0ReactTag);
ABI50_0_0RCT_EXTERN_METHOD(pause:(nonnull NSNumber *)ABI50_0_0ReactTag);
ABI50_0_0RCT_EXTERN_METHOD(resume:(nonnull NSNumber *)ABI50_0_0ReactTag);

@end

