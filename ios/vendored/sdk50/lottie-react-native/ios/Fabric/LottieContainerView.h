@class UITraitCollection;
@class NSDictionary;
@class NSString;
@class NSCoder;

#import <ABI50_0_0React/ABI50_0_0RCTView.h>

@protocol LottieContainerViewDelegate
- (void)onAnimationFinishWithIsCancelled:(BOOL)isCancelled;
- (void)onAnimationFailureWithError:(NSString*)error;
- (void)onAnimationLoaded;
@end

@interface LottieContainerView : ABI50_0_0RCTView
@property (nonatomic, weak) id <LottieContainerViewDelegate> _Nullable delegate;
- (void)traitCollectionDidChange:(UITraitCollection * _Nullable)previousTraitCollection;
- (void)setSpeed:(CGFloat)newSpeed;
- (void)setProgress:(CGFloat)newProgress;
- (void)ABI50_0_0ReactSetFrame:(CGRect)frame;
- (void)setLoop:(BOOL)isLooping;
- (void)setAutoPlay:(BOOL)isAutoPlay;
- (void)setTextFiltersIOS:(NSArray<NSDictionary *> * _Nonnull)newTextFilters;
- (void)setRenderMode:(NSString * _Nonnull)newRenderMode;
- (void)setSourceURL:(NSString * _Nonnull)newSourceURLString;
- (void)setSourceJson:(NSString * _Nonnull)newSourceJson;
- (void)setSourceName:(NSString * _Nonnull)newSourceName;
- (void)setSourceDotLottieURI:(NSString * _Nonnull)uri;
- (void)setResizeMode:(NSString * _Nonnull)resizeMode;
- (void)setColorFilters:(NSArray<NSDictionary *> * _Nonnull)newColorFilters;
- (void)play;
- (void)playFromFrame:(NSNumber * _Nullable)fromFrame toFrame:(CGFloat)toFrame;
- (void)reset;
- (void)pause;
- (void)resume;
- (nonnull instancetype)initWithFrame:(CGRect)frame;
- (nullable instancetype)initWithCoder:(NSCoder * _Nonnull)coder;
@end
