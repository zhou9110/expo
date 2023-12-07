#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0SkiaDrawView.h>

#import <ABI50_0_0RNSkDomView.h>
#import <ABI50_0_0RNSkIOSView.h>
#import <ABI50_0_0RNSkPlatformContext.h>

#import <ABI50_0_0RNSkJsView.h>
#import <ABI50_0_0SkiaUIView.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>

#import <react/renderer/components/rnskia/ComponentDescriptors.h>
#import <react/renderer/components/rnskia/EventEmitters.h>
#import <react/renderer/components/rnskia/Props.h>
#import <react/renderer/components/rnskia/ABI50_0_0RCTComponentViewHelpers.h>

using namespace ABI50_0_0facebook::ABI50_0_0React;

@implementation ABI50_0_0SkiaDrawView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self prepareView];
    static const auto defaultProps =
        std::make_shared<const ABI50_0_0SkiaDrawViewProps>();
    _props = defaultProps;
  }
  return self;
}

- (void)prepareView {
  auto skManager = [[self skiaManager] skManager];
  // Pass SkManager as a raw pointer to avoid circular dependenciesr
  [self initCommon:skManager.get()
           factory:[](std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext> context) {
             return std::make_shared<ABI50_0_0RNSkiOSView<ABI50_0_0RNSkia::ABI50_0_0RNSkJsView>>(context);
           }];
}

- (void)prepareForRecycle {
  [super prepareForRecycle];
  [self prepareView];
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<ABI50_0_0SkiaDrawViewComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props
           oldProps:(const Props::Shared &)oldProps {
  const auto &newProps =
      *std::static_pointer_cast<const ABI50_0_0SkiaDrawViewProps>(props);
  [super updateProps:props oldProps:oldProps];
  int nativeId =
      [[ABI50_0_0RCTConvert NSString:ABI50_0_0RCTNSStringFromString(newProps.nativeId)] intValue];
  [self setNativeId:nativeId];
  [self setDrawingMode:newProps.mode];
  [self setDebugMode:newProps.debug];
}

@end

Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0SkiaDrawViewCls(void) {
  return ABI50_0_0SkiaDrawView.class;
}

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
