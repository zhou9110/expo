#import <ABI50_0_0RNReanimated/ABI50_0_0REAAnimationsManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASharedElement.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASharedTransitionManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASwizzledUIManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentData.h>
#import <ABI50_0_0React/ABI50_0_0RCTTextView.h>
#import <ABI50_0_0React/ABI50_0_0UIView+Private.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>

typedef NS_ENUM(NSInteger, FrameConfigType) { EnteringFrame, ExitingFrame };

BOOL ABI50_0_0REANodeFind(id<ABI50_0_0RCTComponent> view, int (^block)(id<ABI50_0_0RCTComponent>))
{
  if (!view.ABI50_0_0ReactTag) {
    return NO;
  }

  if (block(view)) {
    return YES;
  }

  for (id<ABI50_0_0RCTComponent> subview in view.ABI50_0_0ReactSubviews) {
    if (ABI50_0_0REANodeFind(subview, block)) {
      return YES;
    }
  }

  return NO;
}

@implementation ABI50_0_0REAAnimationsManager {
  ABI50_0_0RCTUIManager *_uiManager;
  ABI50_0_0REASwizzledUIManager *_reaSwizzledUIManager;
  NSMutableSet<NSNumber *> *_enteringViews;
  NSMutableDictionary<NSNumber *, ABI50_0_0REASnapshot *> *_enteringViewTargetValues;
  NSMutableDictionary<NSNumber *, ABI50_0_0REAUIView *> *_exitingViews;
  NSMutableDictionary<NSNumber *, NSNumber *> *_exitingSubviewsCountMap;
  NSMutableDictionary<NSNumber *, NSNumber *> *_exitingParentTags;
  NSMutableSet<NSNumber *> *_ancestorsToRemove;
  NSMutableArray<NSString *> *_targetKeys;
  NSMutableArray<NSString *> *_currentKeys;
  ABI50_0_0REAAnimationStartingBlock _startAnimationForTag;
  ABI50_0_0REAHasAnimationBlock _hasAnimationForTag;
  ABI50_0_0REAShouldAnimateExitingBlock _shouldAnimateExiting;
  ABI50_0_0REAAnimationRemovingBlock _clearAnimationConfigForTag;
  ABI50_0_0REASharedTransitionManager *_sharedTransitionManager;
#ifndef NDEBUG
  ABI50_0_0REACheckDuplicateSharedTagBlock _checkDuplicateSharedTag;
#endif
}

+ (NSArray *)layoutKeys
{
  static NSArray *_array;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _array = @[ @"originX", @"originY", @"width", @"height" ];
  });
  return _array;
}

- (instancetype)initWithUIManager:(ABI50_0_0RCTUIManager *)uiManager
{
  if (self = [super init]) {
    _uiManager = uiManager;
    _exitingViews = [NSMutableDictionary new];
    _exitingSubviewsCountMap = [NSMutableDictionary new];
    _ancestorsToRemove = [NSMutableSet new];
    _exitingParentTags = [NSMutableDictionary new];
    _enteringViews = [NSMutableSet new];
    _enteringViewTargetValues = [NSMutableDictionary new];

    _targetKeys = [NSMutableArray new];
    _currentKeys = [NSMutableArray new];
    for (NSString *key in [[self class] layoutKeys]) {
      [_targetKeys addObject:[NSString stringWithFormat:@"target%@", [key capitalizedString]]];
      [_currentKeys addObject:[NSString stringWithFormat:@"current%@", [key capitalizedString]]];
    }
    _sharedTransitionManager = [[ABI50_0_0REASharedTransitionManager alloc] initWithAnimationsManager:self];
    _reaSwizzledUIManager = [[ABI50_0_0REASwizzledUIManager alloc] initWithUIManager:uiManager withAnimationManager:self];

    _startAnimationForTag = ^(NSNumber *tag, LayoutAnimationType type, NSDictionary *yogaValues) {
      // default implementation, this block will be replaced by a setter
    };
    _hasAnimationForTag = ^(NSNumber *tag, LayoutAnimationType type) {
      // default implementation, this block will be replaced by a setter
      return NO;
    };
    _shouldAnimateExiting = ^(NSNumber *tag, BOOL shouldAnimate) {
      // default implementation, this block will be replaced by a setter
      return YES;
    };
    _clearAnimationConfigForTag = ^(NSNumber *tag) {
      // default implementation, this block will be replaced by a setter
    };
#ifndef NDEBUG
    _checkDuplicateSharedTag = ^(ABI50_0_0REAUIView *view, NSNumber *viewTag) {
      // default implementation, this block will be replaced by a setter
    };
#endif
  }
  return self;
}

- (void)invalidate
{
  _startAnimationForTag = nil;
  _hasAnimationForTag = nil;
  _uiManager = nil;
  _exitingViews = nil;
  _targetKeys = nil;
  _currentKeys = nil;
}

- (void)setAnimationStartingBlock:(ABI50_0_0REAAnimationStartingBlock)startAnimation
{
  _startAnimationForTag = startAnimation;
}

- (void)setHasAnimationBlock:(ABI50_0_0REAHasAnimationBlock)hasAnimation
{
  _hasAnimationForTag = hasAnimation;
}

- (void)setShouldAnimateExitingBlock:(ABI50_0_0REAShouldAnimateExitingBlock)shouldAnimateExiting
{
  _shouldAnimateExiting = shouldAnimateExiting;
}

- (void)setAnimationRemovingBlock:(ABI50_0_0REAAnimationRemovingBlock)clearAnimation
{
  _clearAnimationConfigForTag = clearAnimation;
}

#ifndef NDEBUG
- (void)setCheckDuplicateSharedTagBlock:(ABI50_0_0REACheckDuplicateSharedTagBlock)checkDuplicateSharedTag
{
  _checkDuplicateSharedTag = checkDuplicateSharedTag;
}
#endif

- (ABI50_0_0REAUIView *)viewForTag:(NSNumber *)tag
{
  ABI50_0_0REAUIView *view;
  (view = [_uiManager viewForABI50_0_0ReactTag:tag]) || (view = [_exitingViews objectForKey:tag]) ||
      (view = [_sharedTransitionManager getTransitioningView:tag]);
  return view;
}

- (void)endLayoutAnimationForTag:(NSNumber *)tag removeView:(BOOL)removeView
{
  ABI50_0_0REAUIView *view = [self viewForTag:tag];

  if (view == nil) {
    return;
  }
  if ([_enteringViews containsObject:tag] && !removeView) {
    ABI50_0_0REASnapshot *target = _enteringViewTargetValues[tag];
    if (target != nil) {
      [self setNewProps:target.values forView:view];
    }
  }
  [_enteringViews removeObject:tag];
  [_enteringViewTargetValues removeObjectForKey:tag];

  if (removeView) {
    [self endAnimationsRecursive:view];
    [view removeFromSuperview];
  }
  [_sharedTransitionManager finishSharedAnimation:[self viewForTag:tag] removeView:removeView];
}

- (void)endAnimationsRecursive:(ABI50_0_0REAUIView *)view
{
  NSNumber *tag = [view ABI50_0_0ReactTag];

  if (tag == nil) {
    return;
  }

  // we'll remove this view anyway when exiting from recursion,
  // no need to remove it in `maybeDropAncestors`
  [_ancestorsToRemove removeObject:tag];

  for (ABI50_0_0REAUIView *child in [[view subviews] copy]) {
    [self endAnimationsRecursive:child];
  }

  if ([_exitingViews objectForKey:tag]) {
    [_exitingViews removeObjectForKey:tag];
    [self maybeDropAncestors:view];
  }
}

- (void)progressLayoutAnimationWithStyle:(NSDictionary *)newStyle
                                  forTag:(NSNumber *)tag
                      isSharedTransition:(BOOL)isSharedTransition
{
  [self setNewProps:[newStyle mutableCopy] forView:[self viewForTag:tag] convertFromAbsolute:isSharedTransition];
}

- (double)getDoubleOrZero:(NSNumber *)number
{
  double doubleValue = [number doubleValue];
  if (doubleValue != doubleValue) { // NaN != NaN
    return 0;
  }
  return doubleValue;
}

- (void)setNewProps:(NSMutableDictionary *)newProps forView:(ABI50_0_0REAUIView *)view
{
  [self setNewProps:newProps forView:view convertFromAbsolute:NO];
}

- (void)setNewProps:(NSMutableDictionary *)newProps
                forView:(ABI50_0_0REAUIView *)view
    convertFromAbsolute:(BOOL)convertFromAbsolute
{
  if (newProps[@"height"]) {
    double height = [self getDoubleOrZero:newProps[@"height"]];
    double oldHeight = view.bounds.size.height;
    view.bounds = CGRectMake(0, 0, view.bounds.size.width, height);
    view.center = CGPointMake(view.center.x, view.center.y - oldHeight / 2.0 + view.bounds.size.height / 2.0);
    [newProps removeObjectForKey:@"height"];
  }
  if (newProps[@"width"]) {
    double width = [self getDoubleOrZero:newProps[@"width"]];
    double oldWidth = view.bounds.size.width;
    view.bounds = CGRectMake(0, 0, width, view.bounds.size.height);
    view.center = CGPointMake(view.center.x + view.bounds.size.width / 2.0 - oldWidth / 2.0, view.center.y);
    [newProps removeObjectForKey:@"width"];
  }

  bool needsViewPositionUpdate = false;
  double centerX = view.center.x;
  double centerY = view.center.y;
  if (newProps[@"originX"]) {
    needsViewPositionUpdate = true;
    double originX = [self getDoubleOrZero:newProps[@"originX"]];
    [newProps removeObjectForKey:@"originX"];
    centerX = originX + view.bounds.size.width / 2.0;
  }
  if (newProps[@"originY"]) {
    needsViewPositionUpdate = true;
    double originY = [self getDoubleOrZero:newProps[@"originY"]];
    [newProps removeObjectForKey:@"originY"];
    centerY = originY + view.bounds.size.height / 2.0;
  }
  if (needsViewPositionUpdate) {
    CGPoint newCenter = CGPointMake(centerX, centerY);
    if (convertFromAbsolute) {
      ABI50_0_0REAUIView *window = UIApplication.sharedApplication.keyWindow;
      CGPoint convertedCenter = [window convertPoint:newCenter toView:view.superview];
      view.center = convertedCenter;
    } else {
      view.center = newCenter;
    }
  }

  if (newProps[@"transformMatrix"]) {
    NSArray *matrix = newProps[@"transformMatrix"];
    CGFloat a = [matrix[0] floatValue];
    CGFloat b = [matrix[1] floatValue];
    CGFloat c = [matrix[3] floatValue];
    CGFloat d = [matrix[4] floatValue];
    CGFloat tx = [matrix[6] floatValue];
    CGFloat ty = [matrix[7] floatValue];
    view.transform = CGAffineTransformMake(a, b, c, d, tx, ty);
    [newProps removeObjectForKey:@"transformMatrix"];
  }

  NSMutableDictionary *componentDataByName = [_uiManager valueForKey:@"_componentDataByName"];
  ABI50_0_0RCTComponentData *componentData = componentDataByName[@"RCTView"];
  [componentData setProps:newProps forView:view];
}

- (NSDictionary *)prepareDataForAnimatingWorklet:(NSMutableDictionary *)values frameConfig:(FrameConfigType)frameConfig
{
  if (frameConfig == EnteringFrame) {
    NSDictionary *preparedData = @{
      @"targetWidth" : values[@"width"],
      @"targetHeight" : values[@"height"],
      @"targetOriginX" : values[@"originX"],
      @"targetOriginY" : values[@"originY"],
      @"targetGlobalOriginX" : values[@"globalOriginX"],
      @"targetGlobalOriginY" : values[@"globalOriginY"],
      @"windowWidth" : values[@"windowWidth"],
      @"windowHeight" : values[@"windowHeight"]
    };
    return preparedData;
  } else {
    NSDictionary *preparedData = @{
      @"currentWidth" : values[@"width"],
      @"currentHeight" : values[@"height"],
      @"currentOriginX" : values[@"originX"],
      @"currentOriginY" : values[@"originY"],
      @"currentGlobalOriginX" : values[@"globalOriginX"],
      @"currentGlobalOriginY" : values[@"globalOriginY"],
      @"windowWidth" : values[@"windowWidth"],
      @"windowHeight" : values[@"windowHeight"]
    };
    return preparedData;
  }
}

- (NSMutableDictionary *)prepareDataForLayoutAnimatingWorklet:(NSMutableDictionary *)currentValues
                                                 targetValues:(NSMutableDictionary *)targetValues
{
  NSMutableDictionary *preparedData = [NSMutableDictionary new];
  preparedData[@"currentWidth"] = currentValues[@"width"];
  preparedData[@"currentHeight"] = currentValues[@"height"];
  preparedData[@"currentOriginX"] = currentValues[@"originX"];
  preparedData[@"currentOriginY"] = currentValues[@"originY"];
  preparedData[@"currentGlobalOriginX"] = currentValues[@"globalOriginX"];
  preparedData[@"currentGlobalOriginY"] = currentValues[@"globalOriginY"];
  preparedData[@"targetWidth"] = targetValues[@"width"];
  preparedData[@"targetHeight"] = targetValues[@"height"];
  preparedData[@"targetOriginX"] = targetValues[@"originX"];
  preparedData[@"targetOriginY"] = targetValues[@"originY"];
  preparedData[@"targetGlobalOriginX"] = targetValues[@"globalOriginX"];
  preparedData[@"targetGlobalOriginY"] = targetValues[@"globalOriginY"];
  preparedData[@"windowWidth"] = currentValues[@"windowWidth"];
  preparedData[@"windowHeight"] = currentValues[@"windowHeight"];
  return preparedData;
}

- (void)registerExitingAncestors:(ABI50_0_0REAUIView *)child
{
  [self registerExitingAncestors:child exitingSubviewsCount:1];
}

- (void)registerExitingAncestors:(ABI50_0_0REAUIView *)child exitingSubviewsCount:(int)exitingSubviewsCount
{
  NSNumber *childTag = child.ABI50_0_0ReactTag;
  ABI50_0_0REAUIView *parent = child.superview;

  UIViewController *childController = child.ABI50_0_0ReactViewController;

  // only register ancestors whose `ABI50_0_0ReactViewController` is the same as `child`'s.
  // The idea is that, if a whole ViewController is unmounted, we won't want to run
  // the exiting animation since all the views will disappear immediately anyway
  while (parent != nil && parent.ABI50_0_0ReactViewController == childController &&
         ![parent isKindOfClass:[ABI50_0_0RCTRootView class]]) {
    NSNumber *parentTag = parent.ABI50_0_0ReactTag;
    if (parentTag != nil) {
      _exitingSubviewsCountMap[parent.ABI50_0_0ReactTag] =
          @([_exitingSubviewsCountMap[parent.ABI50_0_0ReactTag] intValue] + exitingSubviewsCount);
      _exitingParentTags[childTag] = parentTag;
      childTag = parentTag;
    }
    parent = parent.superview;
  }
}

- (void)maybeDropAncestors:(ABI50_0_0REAUIView *)child
{
  ABI50_0_0REAUIView *parent = child.superview;
  NSNumber *parentTag = _exitingParentTags[child.ABI50_0_0ReactTag];
  [_exitingParentTags removeObjectForKey:child.ABI50_0_0ReactTag];

  while ((parent != nil || parentTag != nil) && ![parent isKindOfClass:[ABI50_0_0RCTRootView class]]) {
    ABI50_0_0REAUIView *view = parent;
    NSNumber *viewTag = parentTag;
    parentTag = _exitingParentTags[viewTag];
    ABI50_0_0REAUIView *viewByTag = [self viewForTag:viewTag];
    parent = view.superview;

    if (view == nil) {
      if (viewByTag == nil) {
        // the view was already removed from both native and RN hierarchies
        // we can safely forget that it had any animated children
        [_ancestorsToRemove removeObject:viewTag];
        [_exitingSubviewsCountMap removeObjectForKey:viewTag];
        [_exitingParentTags removeObjectForKey:viewTag];
        continue;
      }
      // the child was dettached from view, but view is still
      // in the native and RN hierarchy
      view = viewByTag;
    }

    if (view.ABI50_0_0ReactTag == nil) {
      // we skip over views with no tag when registering parent tags,
      // so we shouldn't go to the parent of viewTag yet
      parentTag = viewTag;
      continue;
    }

    int trackingCount = [_exitingSubviewsCountMap[view.ABI50_0_0ReactTag] intValue] - 1;
    if (trackingCount <= 0) {
      if ([_ancestorsToRemove containsObject:view.ABI50_0_0ReactTag]) {
        [_ancestorsToRemove removeObject:view.ABI50_0_0ReactTag];
        if (![_exitingViews objectForKey:view.ABI50_0_0ReactTag]) {
          [view removeFromSuperview];
        }
      }
      [_exitingSubviewsCountMap removeObjectForKey:view.ABI50_0_0ReactTag];
      [_exitingParentTags removeObjectForKey:view.ABI50_0_0ReactTag];
    } else {
      _exitingSubviewsCountMap[view.ABI50_0_0ReactTag] = @(trackingCount);
    }
  }
}

- (BOOL)startAnimationsRecursive:(ABI50_0_0REAUIView *)view
    shouldRemoveSubviewsWithoutAnimations:(BOOL)shouldRemoveSubviewsWithoutAnimations
                            shouldAnimate:(BOOL)shouldAnimate;
{
  if (!view.ABI50_0_0ReactTag) {
    return NO;
  }

  UIViewController *viewController = view.ABI50_0_0ReactViewController;

  // `startAnimationsRecursive:shouldRemoveSubviewsWithoutAnimations:`
  // is called on a detached view tree, so the `viewController` should be `nil`.
  // If it's not, we're descending into another `UIViewController`.
  // We don't want to run animations inside it (since it causes issues with ABI50_0_0RNScreens),
  // so instead clean up the subtree and return `NO`.
  if (viewController != nil) {
    [self removeAnimationsFromSubtree:view];
    return NO;
  }

  shouldAnimate = [self shouldAnimateExiting:view.ABI50_0_0ReactTag shouldAnimate:shouldAnimate];

  BOOL hasExitAnimation = shouldAnimate &&
      ([self hasAnimationForTag:view.ABI50_0_0ReactTag type:EXITING] || [_exitingViews objectForKey:view.ABI50_0_0ReactTag]);
  BOOL hasAnimatedChildren = NO;
  shouldRemoveSubviewsWithoutAnimations = shouldRemoveSubviewsWithoutAnimations && !hasExitAnimation;
  NSMutableArray *toBeRemoved = [[NSMutableArray alloc] init];

  for (ABI50_0_0REAUIView *subview in [view.ABI50_0_0ReactSubviews copy]) {
    if ([self startAnimationsRecursive:subview
            shouldRemoveSubviewsWithoutAnimations:shouldRemoveSubviewsWithoutAnimations
                                    shouldAnimate:shouldAnimate]) {
      hasAnimatedChildren = YES;
    } else if (shouldRemoveSubviewsWithoutAnimations) {
      [toBeRemoved addObject:subview];
    }
  }

  BOOL wantAnimateExit = hasExitAnimation || hasAnimatedChildren;

  ABI50_0_0REASnapshot *before;
  if (hasExitAnimation) {
    before = [[ABI50_0_0REASnapshot alloc] init:view];
  }

  // start exit animation
  if (hasExitAnimation && ![_exitingViews objectForKey:view.ABI50_0_0ReactTag]) {
    NSDictionary *preparedValues = [self prepareDataForAnimatingWorklet:before.values frameConfig:ExitingFrame];
    [_exitingViews setObject:view forKey:view.ABI50_0_0ReactTag];
    [self registerExitingAncestors:view];
    _startAnimationForTag(view.ABI50_0_0ReactTag, EXITING, preparedValues);
  }

  // NOTE: even though this view is still visible,
  // since it's removed from the ABI50_0_0React tree, we won't
  // start new animations for it, and might as well remove
  // the layout animation config now
  _clearAnimationConfigForTag(view.ABI50_0_0ReactTag);

  if (!wantAnimateExit) {
    return NO;
  }

  if (hasAnimatedChildren) {
    [_ancestorsToRemove addObject:view.ABI50_0_0ReactTag];
  }

  for (ABI50_0_0REAUIView *child in toBeRemoved) {
    [view removeABI50_0_0ReactSubview:child];
  }

  // we don't want user interaction on exiting views
  view.userInteractionEnabled = NO;

  return YES;
}

- (void)reattachAnimatedChildren:(NSArray<id<ABI50_0_0RCTComponent>> *)children
                     toContainer:(id<ABI50_0_0RCTComponent>)container
                       atIndices:(NSArray<NSNumber *> *)indices
{
  if (![container isKindOfClass:[ABI50_0_0REAUIView class]]) {
    return;
  }

  // since we reattach only some of the views,
  // we count the views we DIDN'T reattach
  // and shift later views' indices by that number
  // to make sure they appear at correct relative posisitons
  // in the `subviews` array
  int skippedViewsCount = 0;

  for (int i = 0; i < children.count; i++) {
    id<ABI50_0_0RCTComponent> child = children[i];
    if (![child isKindOfClass:[ABI50_0_0REAUIView class]]) {
      skippedViewsCount++;
      continue;
    }
    ABI50_0_0REAUIView *childView = (ABI50_0_0REAUIView *)child;
    NSNumber *originalIndex = indices[i];
    if ([self startAnimationsRecursive:childView shouldRemoveSubviewsWithoutAnimations:YES shouldAnimate:YES]) {
      [(ABI50_0_0REAUIView *)container insertSubview:childView atIndex:[originalIndex intValue] - skippedViewsCount];
      int exitingSubviewsCount = [_exitingSubviewsCountMap[childView.ABI50_0_0ReactTag] intValue];
      if ([_exitingViews objectForKey:childView.ABI50_0_0ReactTag] != nil) {
        exitingSubviewsCount++;
      }
      [self registerExitingAncestors:childView exitingSubviewsCount:exitingSubviewsCount];
    } else {
      skippedViewsCount++;
    }
  }
}

- (void)onViewCreate:(ABI50_0_0REAUIView *)view after:(ABI50_0_0REASnapshot *)after
{
  NSMutableDictionary *targetValues = after.values;
  NSDictionary *preparedValues = [self prepareDataForAnimatingWorklet:targetValues frameConfig:EnteringFrame];
  [_enteringViews addObject:view.ABI50_0_0ReactTag];
  _startAnimationForTag(view.ABI50_0_0ReactTag, ENTERING, preparedValues);
}

- (void)onViewUpdate:(ABI50_0_0REAUIView *)view before:(ABI50_0_0REASnapshot *)before after:(ABI50_0_0REASnapshot *)after
{
  NSMutableDictionary *targetValues = after.values;
  NSMutableDictionary *currentValues = before.values;

  NSDictionary *preparedValues = [self prepareDataForLayoutAnimatingWorklet:currentValues targetValues:targetValues];
  _startAnimationForTag(view.ABI50_0_0ReactTag, LAYOUT, preparedValues);
}

- (ABI50_0_0REASnapshot *)prepareSnapshotBeforeMountForView:(ABI50_0_0REAUIView *)view
{
  return [[ABI50_0_0REASnapshot alloc] init:view];
}

- (void)removeAnimationsFromSubtree:(ABI50_0_0REAUIView *)view
{
  ABI50_0_0REANodeFind(view, ^int(id<ABI50_0_0RCTComponent> view) {
    if (!self->_hasAnimationForTag(view.ABI50_0_0ReactTag, SHARED_ELEMENT_TRANSITION)) {
      self->_clearAnimationConfigForTag(view.ABI50_0_0ReactTag);
    }
    return false;
  });
}

- (void)viewDidMount:(ABI50_0_0REAUIView *)view withBeforeSnapshot:(nonnull ABI50_0_0REASnapshot *)before withNewFrame:(CGRect)frame
{
  LayoutAnimationType type = before == nil ? ENTERING : LAYOUT;
  NSNumber *viewTag = view.ABI50_0_0ReactTag;
  if (_hasAnimationForTag(viewTag, type)) {
    ABI50_0_0REASnapshot *after = [[ABI50_0_0REASnapshot alloc] init:view];
    if (before == nil) {
      [self onViewCreate:view after:after];
    } else {
      [self onViewUpdate:view before:before after:after];
    }
  } else if (type == LAYOUT && [_enteringViews containsObject:[view ABI50_0_0ReactTag]]) {
    _enteringViewTargetValues[[view ABI50_0_0ReactTag]] = [[ABI50_0_0REASnapshot alloc] init:view];
    [self setNewProps:before.values forView:view];
  }

  if (_hasAnimationForTag(viewTag, SHARED_ELEMENT_TRANSITION)) {
    if (type == ENTERING) {
      [_sharedTransitionManager notifyAboutNewView:view];
#ifndef NDEBUG
      _checkDuplicateSharedTag(view, viewTag);
#endif
    } else {
      [_sharedTransitionManager notifyAboutViewLayout:view withViewFrame:frame];
    }
  }
}

- (void)viewsDidLayout
{
  [_sharedTransitionManager viewsDidLayout];
}

- (void)setFindPrecedingViewTagForTransitionBlock:
    (ABI50_0_0REAFindPrecedingViewTagForTransitionBlock)findPrecedingViewTagForTransition
{
  [_sharedTransitionManager setFindPrecedingViewTagForTransitionBlock:findPrecedingViewTagForTransition];
}

- (void)setCancelAnimationBlock:(ABI50_0_0REACancelAnimationBlock)animationCancellingBlock
{
  [_sharedTransitionManager setCancelAnimationBlock:animationCancellingBlock];
}

- (BOOL)hasAnimationForTag:(NSNumber *)tag type:(LayoutAnimationType)type
{
  return _hasAnimationForTag(tag, type);
}

- (BOOL)shouldAnimateExiting:(NSNumber *)tag shouldAnimate:(BOOL)shouldAnimate
{
  return _shouldAnimateExiting(tag, shouldAnimate);
}

- (void)clearAnimationConfigForTag:(NSNumber *)tag
{
  _clearAnimationConfigForTag(tag);
}

- (void)startAnimationForTag:(NSNumber *)tag type:(LayoutAnimationType)type yogaValues:(NSDictionary *)yogaValues
{
  _startAnimationForTag(tag, type, yogaValues);
}

- (void)onScreenRemoval:(ABI50_0_0REAUIView *)screen stack:(ABI50_0_0REAUIView *)stack
{
  [_sharedTransitionManager onScreenRemoval:screen stack:stack];
}

@end
