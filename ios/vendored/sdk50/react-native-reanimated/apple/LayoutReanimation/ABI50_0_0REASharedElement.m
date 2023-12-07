#import <ABI50_0_0RNReanimated/ABI50_0_0REASharedElement.h>

@implementation ABI50_0_0REASharedElement
- (instancetype)initWithSourceView:(ABI50_0_0REAUIView *)sourceView
                sourceViewSnapshot:(ABI50_0_0REASnapshot *)sourceViewSnapshot
                        targetView:(ABI50_0_0REAUIView *)targetView
                targetViewSnapshot:(ABI50_0_0REASnapshot *)targetViewSnapshot
{
  self = [super init];
  _sourceView = sourceView;
  _sourceViewSnapshot = sourceViewSnapshot;
  _targetView = targetView;
  _targetViewSnapshot = targetViewSnapshot;
  _animationType = SHARED_ELEMENT_TRANSITION;
  return self;
}
@end
