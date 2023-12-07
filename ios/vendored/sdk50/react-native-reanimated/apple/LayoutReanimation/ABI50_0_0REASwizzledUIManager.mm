#import <ABI50_0_0RNReanimated/FeaturesConfig.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASwizzledUIManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUIKit.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUtils.h>
#import <ABI50_0_0React/ABI50_0_0RCTLayoutAnimation.h>
#import <ABI50_0_0React/ABI50_0_0RCTLayoutAnimationGroup.h>
#import <ABI50_0_0React/ABI50_0_0RCTRootShadowView.h>
#import <ABI50_0_0React/ABI50_0_0RCTRootViewInternal.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManagerUtils.h>
#import <objc/runtime.h>

@interface ABI50_0_0RCTUIManager (Reanimated)
@property ABI50_0_0REAAnimationsManager *animationsManager;
- (NSArray<id<ABI50_0_0RCTComponent>> *)_childrenToRemoveFromContainer:(id<ABI50_0_0RCTComponent>)container
                                                    atIndices:(NSArray<NSNumber *> *)atIndices;
@end

@implementation ABI50_0_0RCTUIManager (Reanimated)
@dynamic animationsManager;
- (void)setAnimationsManager:(ABI50_0_0REAAnimationsManager *)animationsManager
{
  objc_setAssociatedObject(self, @selector(animationsManager), animationsManager, OBJC_ASSOCIATION_RETAIN);
}
- (id)animationsManager
{
  return objc_getAssociatedObject(self, @selector(animationsManager));
}
@end

@implementation ABI50_0_0REASwizzledUIManager

std::atomic<uint> isFlushingBlocks;
std::atomic<bool> hasPendingBlocks;

- (instancetype)initWithUIManager:(ABI50_0_0RCTUIManager *)uiManager
             withAnimationManager:(ABI50_0_0REAAnimationsManager *)animationsManager
{
  if (self = [super init]) {
    isFlushingBlocks = 0;
    hasPendingBlocks = false;
    [uiManager setAnimationsManager:animationsManager];
    [self swizzleMethods];

    IMP isExecutingUpdatesBatchImpl = imp_implementationWithBlock(^() {
      return hasPendingBlocks || isFlushingBlocks > 0;
    });
    class_addMethod([ABI50_0_0RCTUIManager class], @selector(isExecutingUpdatesBatch), isExecutingUpdatesBatchImpl, "");
  }
  return self;
}

- (void)swizzleMethods
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [ABI50_0_0REAUtils swizzleMethod:@selector(uiBlockWithLayoutUpdateForRootView:)
                   forClass:[ABI50_0_0RCTUIManager class]
                       with:@selector(reanimated_uiBlockWithLayoutUpdateForRootView:)
                  fromClass:[self class]];
    SEL manageChildrenOriginal = @selector
        (_manageChildren:moveFromIndices:moveToIndices:addChildABI50_0_0ReactTags:addAtIndices:removeAtIndices:registry:);
    SEL manageChildrenReanimated =
        @selector(reanimated_manageChildren:
                            moveFromIndices:moveToIndices:addChildABI50_0_0ReactTags:addAtIndices:removeAtIndices:registry:);
    [ABI50_0_0REAUtils swizzleMethod:manageChildrenOriginal
                   forClass:[ABI50_0_0RCTUIManager class]
                       with:manageChildrenReanimated
                  fromClass:[self class]];
    [ABI50_0_0REAUtils swizzleMethod:@selector(addUIBlock:)
                   forClass:[ABI50_0_0RCTUIManager class]
                       with:@selector(reanimated_addUIBlock:)
                  fromClass:[self class]];
    [ABI50_0_0REAUtils swizzleMethod:@selector(prependUIBlock:)
                   forClass:[ABI50_0_0RCTUIManager class]
                       with:@selector(reanimated_prependUIBlock:)
                  fromClass:[self class]];
    [ABI50_0_0REAUtils swizzleMethod:@selector(flushUIBlocksWithCompletion:)
                   forClass:[ABI50_0_0RCTUIManager class]
                       with:@selector(reanimated_flushUIBlocksWithCompletion:)
                  fromClass:[self class]];
  });
}

- (void)reanimated_manageChildren:(NSNumber *)containerTag
                  moveFromIndices:(NSArray<NSNumber *> *)moveFromIndices
                    moveToIndices:(NSArray<NSNumber *> *)moveToIndices
                addChildABI50_0_0ReactTags:(NSArray<NSNumber *> *)addChildABI50_0_0ReactTags
                     addAtIndices:(NSArray<NSNumber *> *)addAtIndices
                  removeAtIndices:(NSArray<NSNumber *> *)removeAtIndices
                         registry:(NSMutableDictionary<NSNumber *, id<ABI50_0_0RCTComponent>> *)registry
{
  bool isLayoutAnimationEnabled = ABI50_0_0reanimated::FeaturesConfig::isLayoutAnimationEnabled();
  id<ABI50_0_0RCTComponent> container;
  NSArray<id<ABI50_0_0RCTComponent>> *permanentlyRemovedChildren;
  BOOL containerIsRootOfViewController = NO;
  ABI50_0_0RCTUIManager *originalSelf = (ABI50_0_0RCTUIManager *)self;
  if (isLayoutAnimationEnabled) {
    container = registry[containerTag];
    permanentlyRemovedChildren = [originalSelf _childrenToRemoveFromContainer:container atIndices:removeAtIndices];

    if ([container isKindOfClass:[ABI50_0_0REAUIView class]]) {
      UIViewController *controller = ((ABI50_0_0REAUIView *)container).ABI50_0_0ReactViewController;
      UIViewController *parentController = ((ABI50_0_0REAUIView *)container).superview.ABI50_0_0ReactViewController;
      containerIsRootOfViewController = controller != parentController;
    }

    // we check if the container we`re removing from is a root view
    // of some view controller. In that case, we skip running exiting animations
    // in its children, to prevent issues with RN Screens.
    if (containerIsRootOfViewController) {
      NSArray<id<ABI50_0_0RCTComponent>> *permanentlyRemovedChildren =
          [originalSelf _childrenToRemoveFromContainer:container atIndices:removeAtIndices];
      for (ABI50_0_0REAUIView *view in permanentlyRemovedChildren) {
        [originalSelf.animationsManager endAnimationsRecursive:view];
        [originalSelf.animationsManager removeAnimationsFromSubtree:view];
      }
      [originalSelf.animationsManager onScreenRemoval:(ABI50_0_0REAUIView *)permanentlyRemovedChildren[0]
                                                stack:(ABI50_0_0REAUIView *)container];
    }
  }

  // call original method
  [self reanimated_manageChildren:containerTag
                  moveFromIndices:moveFromIndices
                    moveToIndices:moveToIndices
                addChildABI50_0_0ReactTags:addChildABI50_0_0ReactTags
                     addAtIndices:addAtIndices
                  removeAtIndices:removeAtIndices
                         registry:registry];

  if (!isLayoutAnimationEnabled) {
    return;
  }

  if (containerIsRootOfViewController) {
    return;
  }

  // we sort the (index, view) pairs to make sure we insert views back in order
  NSMutableArray<NSArray<id> *> *removedViewsWithIndices = [NSMutableArray new];
  for (int i = 0; i < removeAtIndices.count; i++) {
    removedViewsWithIndices[i] = @[ removeAtIndices[i], permanentlyRemovedChildren[i] ];
  }
  [removedViewsWithIndices
      sortUsingComparator:^NSComparisonResult(NSArray<id> *_Nonnull obj1, NSArray<id> *_Nonnull obj2) {
        return [(NSNumber *)obj1[0] compare:(NSNumber *)obj2[0]];
      }];

  [originalSelf.animationsManager reattachAnimatedChildren:permanentlyRemovedChildren
                                               toContainer:container
                                                 atIndices:removeAtIndices];
}

- (ABI50_0_0RCTViewManagerUIBlock)reanimated_uiBlockWithLayoutUpdateForRootView:(ABI50_0_0RCTRootShadowView *)rootShadowView
{
  if (!ABI50_0_0reanimated::FeaturesConfig::isLayoutAnimationEnabled()) {
    return [self reanimated_uiBlockWithLayoutUpdateForRootView:rootShadowView];
  }

  ABI50_0_0RCTUIManager *originalSelf = (ABI50_0_0RCTUIManager *)self;
#if ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 73
  NSPointerArray *affectedShadowViews = [NSPointerArray weakObjectsPointerArray];
#else
  NSHashTable<ABI50_0_0RCTShadowView *> *affectedShadowViews = [NSHashTable weakObjectsHashTable];
#endif
  [rootShadowView layoutWithAffectedShadowViews:affectedShadowViews];

  if (!affectedShadowViews.count) {
    // no frame change results in no UI update block
    return nil;
  }

  typedef struct {
    CGRect frame;
    UIUserInterfaceLayoutDirection layoutDirection;
    BOOL isNew;
    BOOL parentIsNew;
    ABI50_0_0RCTDisplayType displayType;
  } ABI50_0_0RCTFrameData;

  // Construct arrays then hand off to main thread
  NSUInteger count = affectedShadowViews.count;
  NSMutableArray *ABI50_0_0ReactTags = [[NSMutableArray alloc] initWithCapacity:count];
  NSMutableData *framesData = [[NSMutableData alloc] initWithLength:sizeof(ABI50_0_0RCTFrameData) * count];
  {
    NSUInteger index = 0;
    ABI50_0_0RCTFrameData *frameDataArray = (ABI50_0_0RCTFrameData *)framesData.mutableBytes;
    for (ABI50_0_0RCTShadowView *shadowView in affectedShadowViews) {
      ABI50_0_0ReactTags[index] = shadowView.ABI50_0_0ReactTag;
      ABI50_0_0RCTLayoutMetrics layoutMetrics = shadowView.layoutMetrics;
      frameDataArray[index++] = (ABI50_0_0RCTFrameData){
          layoutMetrics.frame,
          layoutMetrics.layoutDirection,
          shadowView.isNewView,
          shadowView.superview.isNewView,
          layoutMetrics.displayType};
    }
  }

  for (ABI50_0_0RCTShadowView *shadowView in affectedShadowViews) {
    // We have to do this after we build the parentsAreNew array.
    shadowView.newView = NO;

    NSNumber *ABI50_0_0ReactTag = shadowView.ABI50_0_0ReactTag;

    if (shadowView.onLayout) {
      CGRect frame = shadowView.layoutMetrics.frame;
      shadowView.onLayout(@{
        @"layout" : @{
          @"x" : @(frame.origin.x),
          @"y" : @(frame.origin.y),
          @"width" : @(frame.size.width),
          @"height" : @(frame.size.height),
        },
      });
    }

    if (ABI50_0_0RCTIsABI50_0_0ReactRootView(ABI50_0_0ReactTag) && [shadowView isKindOfClass:[ABI50_0_0RCTRootShadowView class]]) {
      CGSize contentSize = shadowView.layoutMetrics.frame.size;

      ABI50_0_0RCTExecuteOnMainQueue(^{
        NSMutableDictionary<NSNumber *, ABI50_0_0REAUIView *> *viewRegistry = [self valueForKey:@"_viewRegistry"];
        ABI50_0_0REAUIView *view = viewRegistry[ABI50_0_0ReactTag];
        ABI50_0_0RCTAssert(view != nil, @"view (for ID %@) not found", ABI50_0_0ReactTag);

        ABI50_0_0RCTRootView *rootView = (ABI50_0_0RCTRootView *)[view superview];
        if ([rootView isKindOfClass:[ABI50_0_0RCTRootView class]]) {
          rootView.intrinsicContentSize = contentSize;
        }
      });
    }
  }

  // Perform layout (possibly animated)
  return ^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, ABI50_0_0REAUIView *> *viewRegistry) {
    const ABI50_0_0RCTFrameData *frameDataArray = (const ABI50_0_0RCTFrameData *)framesData.bytes;
    ABI50_0_0RCTLayoutAnimationGroup *layoutAnimationGroup = [uiManager valueForKey:@"_layoutAnimationGroup"];

    __block NSUInteger completionsCalled = 0;

    NSMutableDictionary<NSNumber *, ABI50_0_0REASnapshot *> *snapshotsBefore = [NSMutableDictionary dictionary];

    NSInteger index = 0;
    for (NSNumber *ABI50_0_0ReactTag in ABI50_0_0ReactTags) {
      ABI50_0_0RCTFrameData frameData = frameDataArray[index++];

      ABI50_0_0REAUIView *view = viewRegistry[ABI50_0_0ReactTag];
      CGRect frame = frameData.frame;

      UIUserInterfaceLayoutDirection layoutDirection = frameData.layoutDirection;
      BOOL isNew = frameData.isNew;
      ABI50_0_0RCTLayoutAnimation *updatingLayoutAnimation = isNew ? nil : layoutAnimationGroup.updatingLayoutAnimation;
      BOOL shouldAnimateCreation = isNew && !frameData.parentIsNew;
      ABI50_0_0RCTLayoutAnimation *creatingLayoutAnimation =
          shouldAnimateCreation ? layoutAnimationGroup.creatingLayoutAnimation : nil;
      BOOL isHidden = frameData.displayType == ABI50_0_0RCTDisplayTypeNone;

      void (^completion)(BOOL) = ^(BOOL finished) {
        completionsCalled++;
        if (layoutAnimationGroup.callback && completionsCalled == count) {
          layoutAnimationGroup.callback(@[ @(finished) ]);

          // It's unsafe to call this callback more than once, so we nil it out here
          // to make sure that doesn't happen.
          layoutAnimationGroup.callback = nil;
        }
      };

      if (view.ABI50_0_0ReactLayoutDirection != layoutDirection) {
        view.ABI50_0_0ReactLayoutDirection = layoutDirection;
      }

      if (view.isHidden != isHidden) {
        view.hidden = isHidden;
      }

      // Reanimated changes /start
      ABI50_0_0REASnapshot *snapshotBefore =
          isNew ? nil : [originalSelf.animationsManager prepareSnapshotBeforeMountForView:view];
      snapshotsBefore[ABI50_0_0ReactTag] = snapshotBefore;
      // Reanimated changes /end

      if (creatingLayoutAnimation) {
        // Animate view creation
        [view ABI50_0_0ReactSetFrame:frame];

        CATransform3D finalTransform = view.layer.transform;
        CGFloat finalOpacity = view.layer.opacity;

        NSString *property = creatingLayoutAnimation.property;
        if ([property isEqualToString:@"scaleXY"]) {
          view.layer.transform = CATransform3DMakeScale(0, 0, 0);
        } else if ([property isEqualToString:@"scaleX"]) {
          view.layer.transform = CATransform3DMakeScale(0, 1, 0);
        } else if ([property isEqualToString:@"scaleY"]) {
          view.layer.transform = CATransform3DMakeScale(1, 0, 0);
        } else if ([property isEqualToString:@"opacity"]) {
          view.layer.opacity = 0.0;
        } else {
          ABI50_0_0RCTLogError(@"Unsupported layout animation createConfig property %@", creatingLayoutAnimation.property);
        }

        [creatingLayoutAnimation
              performAnimations:^{
                if ([property isEqualToString:@"scaleX"] || [property isEqualToString:@"scaleY"] ||
                    [property isEqualToString:@"scaleXY"]) {
                  view.layer.transform = finalTransform;
                } else if ([property isEqualToString:@"opacity"]) {
                  view.layer.opacity = finalOpacity;
                }
              }
            withCompletionBlock:completion];

      } else if (updatingLayoutAnimation) {
        // Animate view update
        [updatingLayoutAnimation
              performAnimations:^{
                [view ABI50_0_0ReactSetFrame:frame];
              }
            withCompletionBlock:completion];

      } else {
        // Update without animation
        [view ABI50_0_0ReactSetFrame:frame];
        completion(YES);
      }
    }

    // Reanimated changes /start
    index = 0;
    for (NSNumber *ABI50_0_0ReactTag in ABI50_0_0ReactTags) {
      ABI50_0_0RCTFrameData frameData = frameDataArray[index++];
      ABI50_0_0REAUIView *view = viewRegistry[ABI50_0_0ReactTag];
      BOOL isNew = frameData.isNew;
      CGRect frame = frameData.frame;

      ABI50_0_0REASnapshot *snapshotBefore = snapshotsBefore[ABI50_0_0ReactTag];

      if (isNew || snapshotBefore != nil) {
        [originalSelf.animationsManager viewDidMount:view withBeforeSnapshot:snapshotBefore withNewFrame:frame];
      }
    }

    // Clean up
    // below line serves as this one uiManager->_layoutAnimationGroup = nil;, because we don't have access to the
    // private field
    [uiManager setValue:nil forKey:@"_layoutAnimationGroup"];

    [originalSelf.animationsManager viewsDidLayout];
    // Reanimated changes /end
  };
}

- (void)reanimated_addUIBlock:(ABI50_0_0RCTViewManagerUIBlock)block
{
  ABI50_0_0RCTAssertUIManagerQueue();
  hasPendingBlocks = true;
  [self reanimated_addUIBlock:block];
}

- (void)reanimated_prependUIBlock:(ABI50_0_0RCTViewManagerUIBlock)block
{
  ABI50_0_0RCTAssertUIManagerQueue();
  hasPendingBlocks = true;
  [self reanimated_prependUIBlock:block];
}

- (void)reanimated_flushUIBlocksWithCompletion:(void (^)(void))completion
{
  ABI50_0_0RCTAssertUIManagerQueue();
  if (hasPendingBlocks) {
    ++isFlushingBlocks;
    hasPendingBlocks = false;
    [self reanimated_addUIBlock:^(
              __unused ABI50_0_0RCTUIManager *manager, __unused NSDictionary<NSNumber *, ABI50_0_0REAUIView *> *viewRegistry) {
      --isFlushingBlocks;
    }];
  }
  [self reanimated_flushUIBlocksWithCompletion:completion];
}

@end
