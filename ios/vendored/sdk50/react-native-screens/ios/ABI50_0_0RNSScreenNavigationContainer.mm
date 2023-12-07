#import "ABI50_0_0RNSScreenNavigationContainer.h"
#import "ABI50_0_0RNSScreen.h"
#import "ABI50_0_0RNSScreenContainer.h"

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTFabricComponentsPlugins.h>
#import <react/renderer/components/rnscreens/ComponentDescriptors.h>
#import <react/renderer/components/rnscreens/Props.h>

namespace ABI50_0_0React = ABI50_0_0facebook::ABI50_0_0React;
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

@implementation ABI50_0_0RNSContainerNavigationController

@end

@implementation ABI50_0_0RNSScreenNavigationContainerView

- (void)setupController
{
  self.controller = [[ABI50_0_0RNSContainerNavigationController alloc] init];
  [(ABI50_0_0RNSContainerNavigationController *)self.controller setNavigationBarHidden:YES animated:NO];
  [self addSubview:self.controller.view];
}

- (void)updateContainer
{
  for (ABI50_0_0RNSScreenView *screen in self.ABI50_0_0ReactSubviews) {
    if (screen.activityState == ABI50_0_0RNSActivityStateOnTop) {
      // there should never be more than one screen with `ABI50_0_0RNSActivityStateOnTop`
      // since this component should be used for `tabs` and `drawer` navigators
      [(ABI50_0_0RNSContainerNavigationController *)self.controller setViewControllers:@[ screen.controller ] animated:NO];
      [screen notifyFinishTransitioning];
    }
  }

  [self maybeDismissVC];
}

#pragma mark-- Fabric specific
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
+ (ABI50_0_0React::ComponentDescriptorProvider)componentDescriptorProvider
{
  return ABI50_0_0React::concreteComponentDescriptorProvider<ABI50_0_0React::ABI50_0_0RNSScreenNavigationContainerComponentDescriptor>();
}
#endif

@end

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
Class<ABI50_0_0RCTComponentViewProtocol> ABI50_0_0RNSScreenNavigationContainerCls(void)
{
  return ABI50_0_0RNSScreenNavigationContainerView.class;
}
#endif

@implementation ABI50_0_0RNSScreenNavigationContainerManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
  return [[ABI50_0_0RNSScreenNavigationContainerView alloc] init];
}

@end
