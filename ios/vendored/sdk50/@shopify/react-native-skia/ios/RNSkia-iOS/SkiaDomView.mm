#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <SkiaDomView.h>

#import <ABI50_0_0RNSkDomView.h>
#import <ABI50_0_0RNSkIOSView.h>
#import <ABI50_0_0RNSkPlatformContext.h>

#import <ABI50_0_0RNSkiaModule.h>
#import <ABI50_0_0SkiaManager.h>
#import <ABI50_0_0SkiaUIView.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTConversions.h>
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>

#import <react/renderer/components/rnskia/ComponentDescriptors.h>
#import <react/renderer/components/rnskia/EventEmitters.h>
#import <react/renderer/components/rnskia/Props.h>
#import <react/renderer/components/rnskia/ABI50_0_0RCTComponentViewHelpers.h>

using namespace ABI50_0_0facebook::ABI50_0_0React;

@implementation SkiaDomView

- (instancetype)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    auto skManager = [[self skiaManager] skManager];
    // Pass SkManager as a raw pointer to avoid circular dependenciesr
    [self
        initCommon:skManager.get()
           factory:[](std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext> context) {
             return std::make_shared<ABI50_0_0RNSkiOSView<ABI50_0_0RNSkia::ABI50_0_0RNSkDomView>>(context);
           }];
    static const auto defaultProps = std::make_shared<const SkiaDomViewProps>();
    _props = defaultProps;
  }
  return self;
}

#pragma mark - ABI50_0_0RCTComponentViewProtocol

+ (ComponentDescriptorProvider)componentDescriptorProvider {
  return concreteComponentDescriptorProvider<SkiaDomViewComponentDescriptor>();
}

- (void)updateProps:(const Props::Shared &)props
           oldProps:(const Props::Shared &)oldProps {
  const auto &newProps =
      *std::static_pointer_cast<const SkiaDomViewProps>(props);
  [super updateProps:props oldProps:oldProps];
  int nativeId =
      [[ABI50_0_0RCTConvert NSString:ABI50_0_0RCTNSStringFromString(newProps.nativeId)] intValue];
  [self setNativeId:nativeId];
  [self setDrawingMode:newProps.mode];
  [self setDebugMode:newProps.debug];
}

@end

Class<ABI50_0_0RCTComponentViewProtocol> SkiaDomViewCls(void) {
  return SkiaDomView.class;
}

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
