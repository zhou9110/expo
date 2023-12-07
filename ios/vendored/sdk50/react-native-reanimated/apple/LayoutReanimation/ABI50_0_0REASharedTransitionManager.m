#import <ABI50_0_0RNReanimated/ABI50_0_0REAFrame.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAScreensHelper.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASharedElement.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REASharedTransitionManager.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAUtils.h>

@implementation ABI50_0_0REASharedTransitionManager {
  NSMutableDictionary<NSNumber *, ABI50_0_0REAUIView *> *_sharedTransitionParent;
  NSMutableDictionary<NSNumber *, NSNumber *> *_sharedTransitionInParentIndex;
  NSMutableDictionary<NSNumber *, ABI50_0_0REASnapshot *> *_snapshotRegistry;
  NSMutableDictionary<NSNumber *, ABI50_0_0REAUIView *> *_currentSharedTransitionViews;
  ABI50_0_0REAFindPrecedingViewTagForTransitionBlock _findPrecedingViewTagForTransition;
  ABI50_0_0REACancelAnimationBlock _cancelLayoutAnimation;
  ABI50_0_0REAUIView *_transitionContainer;
  NSMutableArray<ABI50_0_0REAUIView *> *_addedSharedViews;
  BOOL _isSharedTransitionActive;
  NSMutableArray<ABI50_0_0REASharedElement *> *_sharedElements;
  NSMutableDictionary<NSNumber *, ABI50_0_0REASharedElement *> *_sharedElementsLookup;
  ABI50_0_0REAAnimationsManager *_animationManager;
  NSMutableSet<NSNumber *> *_viewsToHide;
  NSMutableArray<ABI50_0_0REAUIView *> *_removedViews;
  NSMutableSet<ABI50_0_0REAUIView *> *_viewsWithCanceledAnimation;
  NSMutableDictionary<NSNumber *, NSNumber *> *_disableCleaningForView;
  NSMutableDictionary<NSNumber *, ABI50_0_0REAUIView *> *_removedViewRegistry;
  NSMutableSet<NSNumber *> *_layoutedSharedViewsTags;
  NSMutableDictionary<NSNumber *, ABI50_0_0REAFrame *> *_layoutedSharedViewsFrame;
  NSMutableSet<ABI50_0_0REAUIView *> *_reattachedViews;
  BOOL _isStackDropped;
  BOOL _isAsyncSharedTransitionConfigured;
  BOOL _isConfigured;
  BOOL _clearScreen;
}

/*
  `_sharedTransitionManager` provides access to current ABI50_0_0REASharedTransitionManager
  instance from swizzled methods in react-native-screens. Swizzled method has
  different context of execution (self != ABI50_0_0REASharedTransitionManager)
*/
static ABI50_0_0REASharedTransitionManager *_sharedTransitionManager;

- (instancetype)initWithAnimationsManager:(ABI50_0_0REAAnimationsManager *)animationManager
{
  if (self = [super init]) {
    _snapshotRegistry = [NSMutableDictionary new];
    _currentSharedTransitionViews = [NSMutableDictionary new];
    _addedSharedViews = [NSMutableArray new];
    _sharedTransitionParent = [NSMutableDictionary new];
    _sharedTransitionInParentIndex = [NSMutableDictionary new];
    _isSharedTransitionActive = NO;
    _sharedElements = [NSMutableArray new];
    _sharedElementsLookup = [NSMutableDictionary new];
    _animationManager = animationManager;
    _viewsToHide = [NSMutableSet new];
    _sharedTransitionManager = self;
    _disableCleaningForView = [NSMutableDictionary new];
    _removedViewRegistry = [NSMutableDictionary new];
    _layoutedSharedViewsTags = [NSMutableSet new];
    _layoutedSharedViewsFrame = [NSMutableDictionary new];
    _reattachedViews = [NSMutableSet new];
    _isAsyncSharedTransitionConfigured = NO;
    _isConfigured = NO;
    [self swizzleScreensMethods];
  }
  return self;
}

- (void)invalidate
{
  _snapshotRegistry = nil;
  _currentSharedTransitionViews = nil;
  _addedSharedViews = nil;
  _sharedTransitionParent = nil;
  _sharedTransitionInParentIndex = nil;
  _sharedElements = nil;
  _animationManager = nil;
}

- (ABI50_0_0REAUIView *)getTransitioningView:(NSNumber *)tag
{
  ABI50_0_0REAUIView *view = _currentSharedTransitionViews[tag];
  if (view == nil) {
    return _removedViewRegistry[tag];
  }
  return view;
}

- (void)notifyAboutNewView:(ABI50_0_0REAUIView *)view
{
  if (!_isConfigured) {
    return;
  }
  [_addedSharedViews addObject:view];
}

- (void)notifyAboutViewLayout:(ABI50_0_0REAUIView *)view withViewFrame:(CGRect)frame
{
  if (!_isConfigured) {
    return;
  }
  [_layoutedSharedViewsTags addObject:view.ABI50_0_0ReactTag];
  float x = frame.origin.x;
  float y = frame.origin.y;
  float width = frame.size.width;
  float height = frame.size.height;
  _layoutedSharedViewsFrame[view.ABI50_0_0ReactTag] = [[ABI50_0_0REAFrame alloc] initWithX:x y:y width:width height:height];
}

- (void)viewsDidLayout
{
  if (!_isConfigured) {
    return;
  }
  [self configureAsyncSharedTransitionForViews:_addedSharedViews];
  [_addedSharedViews removeAllObjects];
  [self maybeRestartAnimationWithNewLayout];
  [_layoutedSharedViewsTags removeAllObjects];
  [_layoutedSharedViewsFrame removeAllObjects];
}

- (void)configureAsyncSharedTransitionForViews:(NSArray<ABI50_0_0REAUIView *> *)views
{
  if ([views count] > 0) {
    NSArray *sharedViews = [self sortViewsByTags:views];
    _sharedElements = [self getSharedElementForCurrentTransition:sharedViews withNewElements:YES];
    [self resolveAnimationType:_sharedElements isInteractive:NO];
    _isAsyncSharedTransitionConfigured = YES;
  }
}

- (void)maybeRestartAnimationWithNewLayout
{
  if ([_layoutedSharedViewsTags count] == 0 || [_currentSharedTransitionViews count] == 0) {
    return;
  }
  NSMutableArray<ABI50_0_0REASharedElement *> *sharedElementToRestart = [NSMutableArray new];
  for (ABI50_0_0REASharedElement *sharedElement in _sharedElements) {
    NSNumber *viewTag = sharedElement.targetView.ABI50_0_0ReactTag;
    if ([_layoutedSharedViewsTags containsObject:viewTag] && _currentSharedTransitionViews[viewTag]) {
      [sharedElementToRestart addObject:sharedElement];
    }
  }

  for (ABI50_0_0REASharedElement *sharedElement in sharedElementToRestart) {
    ABI50_0_0REAUIView *sourceView = sharedElement.sourceView;
    ABI50_0_0REAUIView *targetView = sharedElement.targetView;

    ABI50_0_0REASnapshot *newSourceViewSnapshot = [[ABI50_0_0REASnapshot alloc] initWithAbsolutePosition:sourceView];
    ABI50_0_0REASnapshot *currentTargetViewSnapshot = _snapshotRegistry[targetView.ABI50_0_0ReactTag];
    ABI50_0_0REAFrame *frameData = _layoutedSharedViewsFrame[targetView.ABI50_0_0ReactTag];
    float currentOriginX = [currentTargetViewSnapshot.values[@"originX"] floatValue];
    float currentOriginY = [currentTargetViewSnapshot.values[@"originY"] floatValue];
    float currentOriginXByParent = [currentTargetViewSnapshot.values[@"originXByParent"] floatValue];
    float currentOriginYByParent = [currentTargetViewSnapshot.values[@"originYByParent"] floatValue];
    NSNumber *newOriginX = @(currentOriginX - currentOriginXByParent + frameData.x);
    NSNumber *newOriginY = @(currentOriginY - currentOriginYByParent + frameData.y);
    currentTargetViewSnapshot.values[@"width"] = @(frameData.width);
    currentTargetViewSnapshot.values[@"height"] = @(frameData.height);
    currentTargetViewSnapshot.values[@"originX"] = newOriginX;
    currentTargetViewSnapshot.values[@"originY"] = newOriginY;
    currentTargetViewSnapshot.values[@"globalOriginX"] = newOriginX;
    currentTargetViewSnapshot.values[@"globalOriginY"] = newOriginY;
    currentTargetViewSnapshot.values[@"originXByParent"] = @(frameData.x);
    currentTargetViewSnapshot.values[@"originYByParent"] = @(frameData.y);
    sharedElement.sourceViewSnapshot = newSourceViewSnapshot;

    [self disableCleaningForViewTag:sourceView.ABI50_0_0ReactTag];
    [self disableCleaningForViewTag:targetView.ABI50_0_0ReactTag];
  }
  [self startSharedTransition:sharedElementToRestart];
}

- (BOOL)configureAndStartSharedTransitionForViews:(NSArray<ABI50_0_0REAUIView *> *)views isInteractive:(BOOL)isInteractive
{
  NSArray *sharedViews = [self sortViewsByTags:views];
  NSArray<ABI50_0_0REASharedElement *> *sharedElements = [self getSharedElementForCurrentTransition:sharedViews
                                                                           withNewElements:NO];
  if ([sharedElements count] == 0) {
    return NO;
  }
  [self resolveAnimationType:sharedElements isInteractive:isInteractive];
  [self configureTransitionContainer];
  [self reparentSharedViewsForCurrentTransition:sharedElements];
  [self startSharedTransition:sharedElements];
  return YES;
}

- (NSArray *)sortViewsByTags:(NSArray *)views
{
  /*
    All shared views during the transition have the same parent. It is problematic if parent
    view and their children are in the same transition. To keep the valid order in the z-axis,
    we need to sort views by tags. Parent tag is lower than children tags.
  */
  return [views sortedArrayUsingComparator:^NSComparisonResult(ABI50_0_0REAUIView *view1, ABI50_0_0REAUIView *view2) {
    return [view2.ABI50_0_0ReactTag compare:view1.ABI50_0_0ReactTag];
  }];
}

- (NSMutableArray<ABI50_0_0REASharedElement *> *)getSharedElementForCurrentTransition:(NSArray *)sharedViews
                                                             withNewElements:(BOOL)addedNewScreen
{
  NSMutableArray<ABI50_0_0REAUIView *> *newTransitionViews = [NSMutableArray new];
  NSMutableArray<ABI50_0_0REASharedElement *> *newSharedElements = [NSMutableArray new];
  NSMutableSet<NSNumber *> *currentSharedViewsTags = [NSMutableSet new];
  for (ABI50_0_0REAUIView *sharedView in sharedViews) {
    [currentSharedViewsTags addObject:sharedView.ABI50_0_0ReactTag];
  }
  for (ABI50_0_0REAUIView *sharedView in sharedViews) {
    // add observers
    ABI50_0_0REAUIView *sharedViewScreen = [ABI50_0_0REAScreensHelper getScreenForView:sharedView];
    ABI50_0_0REAUIView *stack = [ABI50_0_0REAScreensHelper getStackForView:sharedViewScreen];

    // find sibling for shared view
    NSNumber *siblingViewTag = _findPrecedingViewTagForTransition(sharedView.ABI50_0_0ReactTag);
    ABI50_0_0REAUIView *siblingView = nil;
    do {
      siblingView = [_animationManager viewForTag:siblingViewTag];
      if (siblingView == nil) {
        [self clearAllSharedConfigsForViewTag:siblingViewTag];
        siblingViewTag = _findPrecedingViewTagForTransition(sharedView.ABI50_0_0ReactTag);
      }
    } while (siblingView == nil && siblingViewTag != nil);

    if (siblingView == nil) {
      // the sibling of shared view doesn't exist yet
      continue;
    }

    ABI50_0_0REAUIView *viewSource;
    ABI50_0_0REAUIView *viewTarget;
    if (addedNewScreen) {
      viewSource = siblingView;
      viewTarget = sharedView;
    } else {
      viewSource = sharedView;
      viewTarget = siblingView;
    }

    bool isInCurrentTransition = false;
    if (_currentSharedTransitionViews[viewSource.ABI50_0_0ReactTag] || _currentSharedTransitionViews[viewTarget.ABI50_0_0ReactTag]) {
      isInCurrentTransition = true;
      if (addedNewScreen) {
        siblingViewTag = _findPrecedingViewTagForTransition(siblingView.ABI50_0_0ReactTag);
        siblingView = [_animationManager viewForTag:siblingViewTag];

        viewSource = siblingView;
        viewTarget = sharedView;
      }
    }

    if ([currentSharedViewsTags containsObject:viewSource.ABI50_0_0ReactTag] &&
        [currentSharedViewsTags containsObject:viewTarget.ABI50_0_0ReactTag]) {
      continue;
    }

    bool isModal = [ABI50_0_0REAScreensHelper isScreenModal:sharedViewScreen];
    // check valid target screen configuration
    int screensCount = [stack.ABI50_0_0ReactSubviews count];
    if (addedNewScreen && !isModal) {
      // is under top
      if (screensCount < 2) {
        continue;
      }
      ABI50_0_0REAUIView *viewSourceParentScreen = [ABI50_0_0REAScreensHelper getScreenForView:viewSource];
      ABI50_0_0REAUIView *screenUnderStackTop = stack.ABI50_0_0ReactSubviews[screensCount - 2];
      if (![screenUnderStackTop.ABI50_0_0ReactTag isEqual:viewSourceParentScreen.ABI50_0_0ReactTag] && !isInCurrentTransition) {
        continue;
      }
    } else if (!addedNewScreen) {
      // is on top
      ABI50_0_0REAUIView *viewTargetParentScreen = [ABI50_0_0REAScreensHelper getScreenForView:viewTarget];
      // TODO macOS navigationController isn't available on macOS
#if !TARGET_OS_OSX
      ABI50_0_0REAUIView *stackTarget = viewTargetParentScreen.ABI50_0_0ReactViewController.navigationController.topViewController.view;
      if (stackTarget != viewTargetParentScreen) {
        continue;
      }
#endif
    }

    if (isModal) {
      [_viewsToHide addObject:viewSource.ABI50_0_0ReactTag];
    }

    ABI50_0_0REASnapshot *sourceViewSnapshot = [[ABI50_0_0REASnapshot alloc] initWithAbsolutePosition:viewSource];
    if (addedNewScreen && !_currentSharedTransitionViews[viewSource.ABI50_0_0ReactTag]) {
      _snapshotRegistry[viewSource.ABI50_0_0ReactTag] = sourceViewSnapshot;
    }

    ABI50_0_0REASnapshot *targetViewSnapshot;
    if (addedNewScreen) {
      targetViewSnapshot = [[ABI50_0_0REASnapshot alloc] initWithAbsolutePosition:viewTarget];
      _snapshotRegistry[viewTarget.ABI50_0_0ReactTag] = targetViewSnapshot;
    } else {
      targetViewSnapshot = _snapshotRegistry[viewTarget.ABI50_0_0ReactTag];
      if (targetViewSnapshot == nil) {
        targetViewSnapshot = [[ABI50_0_0REASnapshot alloc] initWithAbsolutePosition:viewTarget];
      }
    }

    [newTransitionViews addObject:viewSource];
    [newTransitionViews addObject:viewTarget];

    ABI50_0_0REASharedElement *sharedElement = [[ABI50_0_0REASharedElement alloc] initWithSourceView:viewSource
                                                                sourceViewSnapshot:sourceViewSnapshot
                                                                        targetView:viewTarget
                                                                targetViewSnapshot:targetViewSnapshot];
    [newSharedElements addObject:sharedElement];
  }
  if ([newTransitionViews count] > 0) {
    NSMutableArray *currentSourceViews = [NSMutableArray new];
    for (ABI50_0_0REASharedElement *sharedElement in _sharedElements) {
      [currentSourceViews addObject:sharedElement.sourceView];
    }
    NSMutableSet *newSourceViews = [NSMutableSet new];
    for (ABI50_0_0REASharedElement *sharedElement in newSharedElements) {
      [newSourceViews addObject:sharedElement.sourceView];
    }
    for (ABI50_0_0REAUIView *view in currentSourceViews) {
      if (![newSourceViews containsObject:view]) {
        _removedViewRegistry[view.ABI50_0_0ReactTag] = view;
      }
    }
    [_currentSharedTransitionViews removeAllObjects];
    for (ABI50_0_0REAUIView *view in newTransitionViews) {
      _currentSharedTransitionViews[view.ABI50_0_0ReactTag] = view;
    }
  }
  if ([newSharedElements count] != 0) {
    _sharedElements = newSharedElements;
    for (ABI50_0_0REASharedElement *sharedElement in newSharedElements) {
      _sharedElementsLookup[sharedElement.sourceView.ABI50_0_0ReactTag] = sharedElement;
    }
  }
  return newSharedElements;
}

/*
  Method swizzling is used to get notification from react-native-screens
  about push or pop screen from stack.
*/
- (void)swizzleScreensMethods
{
#if LOAD_SCREENS_HEADERS
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    SEL viewDidLayoutSubviewsSelector = @selector(viewDidLayoutSubviews);
    SEL notifyWillDisappearSelector = @selector(notifyWillDisappear);
    Class screenClass = [ABI50_0_0RNSScreen class];
    Class screenViewClass = [ABI50_0_0RNSScreenView class];
    BOOL allSelectorsAreAvailable = [ABI50_0_0RNSScreen instancesRespondToSelector:viewDidLayoutSubviewsSelector] &&
        [ABI50_0_0RNSScreenView instancesRespondToSelector:notifyWillDisappearSelector] &&
        [ABI50_0_0RNSScreenView instancesRespondToSelector:@selector(isModal)]; // used by ABI50_0_0REAScreenHelper

    if (allSelectorsAreAvailable) {
      [ABI50_0_0REAUtils swizzleMethod:viewDidLayoutSubviewsSelector
                     forClass:screenClass
                         with:@selector(reanimated_viewDidLayoutSubviews)
                    fromClass:[self class]];
      [ABI50_0_0REAUtils swizzleMethod:notifyWillDisappearSelector
                     forClass:screenViewClass
                         with:@selector(reanimated_notifyWillDisappear)
                    fromClass:[self class]];
      _isConfigured = YES;
    }
  });
#endif
}

- (void)reanimated_viewDidLayoutSubviews
{
  // call original method from react-native-screens, self == ABI50_0_0RNScreen
  [self reanimated_viewDidLayoutSubviews];
  ABI50_0_0REAUIView *screen = [self valueForKey:@"screenView"];
  [_sharedTransitionManager screenAddedToStack:screen];
}

- (void)reanimated_notifyWillDisappear
{
  // call original method from react-native-screens, self == ABI50_0_0RNSScreenView
  [self reanimated_notifyWillDisappear];
  [_sharedTransitionManager screenRemovedFromStack:(ABI50_0_0REAUIView *)self];
}

- (void)screenAddedToStack:(ABI50_0_0REAUIView *)screen
{
  if (screen.superview != nil) {
    [self runAsyncSharedTransition];
  }
}

- (void)screenRemovedFromStack:(ABI50_0_0REAUIView *)screen
{
  _isStackDropped = NO;
  ABI50_0_0REAUIView *stack = [ABI50_0_0REAScreensHelper getStackForView:screen];
  bool isModal = [ABI50_0_0REAScreensHelper isScreenModal:screen];
  bool isRemovedInParentStack = [self isRemovedFromHigherStack:screen];
  if ((stack != nil || isModal) && !isRemovedInParentStack) {
    bool isInteractive = [self isInteractiveScreenChange:screen];
    // screen is removed from ABI50_0_0React tree (navigation.navigate(<screenName>))
    bool isScreenRemovedFromReactTree = [self isScreen:screen outsideStack:stack];
    // click on button goBack on native header
    bool isTriggeredByGoBackButton = [self isScreen:screen onTopOfStack:stack];
    bool shouldRunTransition = (isScreenRemovedFromReactTree || isTriggeredByGoBackButton) &&
        !(isInteractive && [_currentSharedTransitionViews count] > 0);
    if (shouldRunTransition) {
      [self runSharedTransitionForSharedViewsOnScreen:screen isInteractive:isInteractive];
    } else {
      [self makeSnapshotForScreenViews:screen];
    }
  } else {
    // removed stack
    if (![self isInteractiveScreenChange:screen]) {
      [self clearConfigForStackNow:stack];
    } else {
      _isStackDropped = YES;
    }
  }
}

- (bool)isInteractiveScreenChange:(ABI50_0_0REAUIView *)screen
{
#if !TARGET_OS_OSX
  return screen.ABI50_0_0ReactViewController.transitionCoordinator.interactive;
#else
  // TODO macOS transitionCoordinator isn't available on macOS
  return false;
#endif
}

- (void)makeSnapshotForScreenViews:(ABI50_0_0REAUIView *)screen
{
  ABI50_0_0REANodeFind(screen, ^int(id<ABI50_0_0RCTComponent> view) {
    NSNumber *viewTag = view.ABI50_0_0ReactTag;
    if (self->_currentSharedTransitionViews[viewTag]) {
      return false;
    }
    if ([self->_animationManager hasAnimationForTag:viewTag type:SHARED_ELEMENT_TRANSITION]) {
      ABI50_0_0REASnapshot *snapshot = [[ABI50_0_0REASnapshot alloc] initWithAbsolutePosition:(ABI50_0_0REAUIView *)view];
      self->_snapshotRegistry[viewTag] = snapshot;
    }
    return false;
  });
}

- (void)clearConfigForStackNow:(ABI50_0_0REAUIView *)stack
{
  for (ABI50_0_0REAUIView *screen in stack.ABI50_0_0ReactSubviews) {
    [self clearConfigForScreen:screen];
  }
}

- (BOOL)isScreen:(ABI50_0_0REAUIView *)screen outsideStack:(ABI50_0_0REAUIView *)stack
{
  for (ABI50_0_0REAUIView *child in stack.ABI50_0_0ReactSubviews) {
    if ([child.ABI50_0_0ReactTag isEqual:screen.ABI50_0_0ReactTag]) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)isScreen:(ABI50_0_0REAUIView *)screen onTopOfStack:(ABI50_0_0REAUIView *)stack
{
  int screenCount = stack.ABI50_0_0ReactSubviews.count;
  return screenCount > 0 && screen == stack.ABI50_0_0ReactSubviews.lastObject;
}

- (BOOL)isRemovedFromHigherStack:(ABI50_0_0REAUIView *)screen
{
  ABI50_0_0REAUIView *stack = screen.ABI50_0_0ReactSuperview;
  while (stack != nil) {
#if !TARGET_OS_OSX
    screen = stack.ABI50_0_0ReactViewController.navigationController.topViewController.view;
#else
    // TODO macOS navigationController isn't available on macOS
    screen = nil;
#endif
    if (screen == nil) {
      break;
    }
    if (screen.superview == nil) {
      return YES;
    }
    stack = screen.ABI50_0_0ReactSuperview;
  }
  return NO;
}

- (void)runSharedTransitionForSharedViewsOnScreen:(ABI50_0_0REAUIView *)screen isInteractive:(BOOL)isInteractive
{
  NSMutableArray<ABI50_0_0REAUIView *> *removedViews = [NSMutableArray new];
  ABI50_0_0REANodeFind(screen, ^int(id<ABI50_0_0RCTComponent> view) {
    if ([self->_animationManager hasAnimationForTag:view.ABI50_0_0ReactTag type:SHARED_ELEMENT_TRANSITION]) {
      [removedViews addObject:(ABI50_0_0REAUIView *)view];
    }
    return false;
  });
  BOOL startedAnimation = [self configureAndStartSharedTransitionForViews:removedViews isInteractive:isInteractive];
  if (startedAnimation) {
    _removedViews = removedViews;
  } else if (![self isInteractiveScreenChange:screen]) {
    [self clearConfigForScreen:screen];
  } else {
    _clearScreen = YES;
  }
}

- (void)runAsyncSharedTransition
{
  if ([_sharedElements count] == 0 || !_isAsyncSharedTransitionConfigured) {
    return;
  }
  for (ABI50_0_0REASharedElement *sharedElement in _sharedElements) {
    ABI50_0_0REAUIView *viewTarget = sharedElement.targetView;
    ABI50_0_0REASnapshot *targetViewSnapshot = [[ABI50_0_0REASnapshot alloc] initWithAbsolutePosition:viewTarget];
    _snapshotRegistry[viewTarget.ABI50_0_0ReactTag] = targetViewSnapshot;
    sharedElement.targetViewSnapshot = targetViewSnapshot;
  }

  [self configureTransitionContainer];
  [self reparentSharedViewsForCurrentTransition:_sharedElements];
  [self startSharedTransition:_sharedElements];
  [_addedSharedViews removeAllObjects];
  _isAsyncSharedTransitionConfigured = NO;
}

- (void)configureTransitionContainer
{
  if (!_isSharedTransitionActive) {
    _isSharedTransitionActive = YES;
    ABI50_0_0REAUIView *mainWindow = UIApplication.sharedApplication.keyWindow;
    if (_transitionContainer == nil) {
      _transitionContainer = [ABI50_0_0REAUIView new];
    }
    [mainWindow addSubview:_transitionContainer];
    // TODO macOS bringSubviewToFront isn't available on macOS
#if !TARGET_OS_OSX
    [mainWindow bringSubviewToFront:_transitionContainer];
#endif
  }
}

- (void)reparentSharedViewsForCurrentTransition:(NSArray *)sharedElements
{
  for (ABI50_0_0REASharedElement *sharedElement in sharedElements) {
    ABI50_0_0REAUIView *viewSource = sharedElement.sourceView;
    [_reattachedViews addObject:viewSource];
    if (_sharedTransitionParent[viewSource.ABI50_0_0ReactTag] == nil) {
      _sharedTransitionParent[viewSource.ABI50_0_0ReactTag] = viewSource.superview;
      _sharedTransitionInParentIndex[viewSource.ABI50_0_0ReactTag] = @([viewSource.superview.subviews indexOfObject:viewSource]);
      [viewSource removeFromSuperview];
      [_transitionContainer addSubview:viewSource];
    }
  }
}

- (void)startSharedTransition:(NSArray *)sharedElements
{
  for (ABI50_0_0REASharedElement *sharedElement in sharedElements) {
    sharedElement.targetView.hidden = YES;
    LayoutAnimationType type = sharedElement.animationType;
    [self onViewTransition:sharedElement.sourceView
                    before:sharedElement.sourceViewSnapshot
                     after:sharedElement.targetViewSnapshot
                      type:type];
  }
}

- (void)onViewTransition:(ABI50_0_0REAUIView *)view
                  before:(ABI50_0_0REASnapshot *)before
                   after:(ABI50_0_0REASnapshot *)after
                    type:(LayoutAnimationType)type
{
  NSMutableDictionary *targetValues = after.values;
  NSMutableDictionary *currentValues = before.values;
  // TODO macOS bringSubviewToFront isn't available on macOS
#if !TARGET_OS_OSX
  [view.superview bringSubviewToFront:view];
#endif
  NSDictionary *preparedValues = [self prepareDataForWorklet:currentValues targetValues:targetValues];
  [_animationManager startAnimationForTag:view.ABI50_0_0ReactTag type:type yogaValues:preparedValues];
}

- (void)finishSharedAnimation:(ABI50_0_0REAUIView *)view removeView:(BOOL)removeView
{
  if (!_isConfigured) {
    return;
  }
  NSNumber *viewTag = view.ABI50_0_0ReactTag;
  if (_disableCleaningForView[viewTag]) {
    [self enableCleaningForViewTag:viewTag];
    return;
  }
  ABI50_0_0REASharedElement *sharedElement = _sharedElementsLookup[viewTag];
  if (sharedElement == nil) {
    return;
  }
  [_sharedElementsLookup removeObjectForKey:viewTag];
  if ([_reattachedViews containsObject:view]) {
    [_reattachedViews removeObject:view];
    [view removeFromSuperview];
    ABI50_0_0REAUIView *parent = _sharedTransitionParent[viewTag];
    int childIndex = [_sharedTransitionInParentIndex[viewTag] intValue];
    ABI50_0_0REAUIView *screen = [ABI50_0_0REAScreensHelper getScreenForView:parent];
    bool isScreenInReactTree = screen.ABI50_0_0ReactSuperview != nil;
    if (isScreenInReactTree) {
      [parent insertSubview:view atIndex:childIndex];
      ABI50_0_0REASnapshot *viewSourcePreviousSnapshot = _snapshotRegistry[viewTag];
      [_animationManager progressLayoutAnimationWithStyle:viewSourcePreviousSnapshot.values
                                                   forTag:viewTag
                                       isSharedTransition:YES];
      float originXByParent = [viewSourcePreviousSnapshot.values[@"originXByParent"] floatValue];
      float originYByParent = [viewSourcePreviousSnapshot.values[@"originYByParent"] floatValue];
      CGRect frame = CGRectMake(originXByParent, originYByParent, view.frame.size.width, view.frame.size.height);
      [view setFrame:frame];
    }
    [_sharedTransitionParent removeObjectForKey:viewTag];
    [_sharedTransitionInParentIndex removeObjectForKey:viewTag];
  }

  ABI50_0_0REAUIView *targetView = sharedElement.targetView;
  targetView.hidden = NO;
  if ([_viewsToHide containsObject:viewTag]) {
    view.hidden = YES;
  }
  if (!removeView) {
    [_removedViews removeObject:view];
  }
  if ([_removedViews containsObject:view]) {
    [_animationManager clearAnimationConfigForTag:viewTag];
  }
  if (_removedViewRegistry[view.ABI50_0_0ReactTag]) {
    return;
  }
  if ([_reattachedViews count] == 0) {
    [_transitionContainer removeFromSuperview];
    [_removedViewRegistry removeAllObjects];
    [_currentSharedTransitionViews removeAllObjects];
    [_removedViews removeAllObjects];
    [_sharedElements removeAllObjects];
    [_sharedElementsLookup removeAllObjects];
    [_viewsToHide removeAllObjects];
    _isSharedTransitionActive = NO;
  }
}

- (void)setFindPrecedingViewTagForTransitionBlock:
    (ABI50_0_0REAFindPrecedingViewTagForTransitionBlock)findPrecedingViewTagForTransition
{
  _findPrecedingViewTagForTransition = findPrecedingViewTagForTransition;
}

- (void)setCancelAnimationBlock:(ABI50_0_0REACancelAnimationBlock)cancelAnimationBlock
{
  _cancelLayoutAnimation = cancelAnimationBlock;
}

- (void)clearAllSharedConfigsForViewTag:(NSNumber *)viewTag
{
  if (viewTag != nil) {
    [_snapshotRegistry removeObjectForKey:viewTag];
    [_animationManager clearAnimationConfigForTag:viewTag];
  }
}

- (void)cancelAnimation:(NSNumber *)viewTag
{
  _cancelLayoutAnimation(viewTag);
}

- (void)disableCleaningForViewTag:(NSNumber *)viewTag
{
  NSNumber *counter = _disableCleaningForView[viewTag];
  if (counter != nil) {
    _disableCleaningForView[viewTag] = @([counter intValue] + 1);
  } else {
    _disableCleaningForView[viewTag] = @(1);
  }
}

- (void)enableCleaningForViewTag:(NSNumber *)viewTag
{
  NSNumber *counter = _disableCleaningForView[viewTag];
  if (counter == nil) {
    return;
  }
  int counterInt = [counter intValue];
  if (counterInt == 1) {
    [_disableCleaningForView removeObjectForKey:viewTag];
  } else {
    _disableCleaningForView[viewTag] = @(counterInt - 1);
  }
}

- (void)resolveAnimationType:(NSArray<ABI50_0_0REASharedElement *> *)sharedElements isInteractive:(BOOL)isInteractive
{
  for (ABI50_0_0REASharedElement *sharedElement in sharedElements) {
    NSNumber *viewTag = sharedElement.sourceView.ABI50_0_0ReactTag;
    bool viewHasProgressAnimation = [self->_animationManager hasAnimationForTag:viewTag
                                                                           type:SHARED_ELEMENT_TRANSITION_PROGRESS];
    if (viewHasProgressAnimation || isInteractive) {
      sharedElement.animationType = SHARED_ELEMENT_TRANSITION_PROGRESS;
    } else {
      sharedElement.animationType = SHARED_ELEMENT_TRANSITION;
    }
  }
}

- (NSDictionary *)prepareDataForWorklet:(NSMutableDictionary *)currentValues
                           targetValues:(NSMutableDictionary *)targetValues
{
  NSMutableDictionary *workletValues = [_animationManager prepareDataForLayoutAnimatingWorklet:currentValues
                                                                                  targetValues:targetValues];
  workletValues[@"currentTransformMatrix"] = currentValues[@"transformMatrix"];
  workletValues[@"targetTransformMatrix"] = targetValues[@"transformMatrix"];
  workletValues[@"currentBorderRadius"] = currentValues[@"borderRadius"];
  workletValues[@"targetBorderRadius"] = targetValues[@"borderRadius"];
  return workletValues;
}

- (void)onScreenRemoval:(ABI50_0_0REAUIView *)screen stack:(ABI50_0_0REAUIView *)stack
{
  if (_isStackDropped && screen != nil) {
    // to clear config from stack after swipe back
    [self clearConfigForStackNow:stack];
    _isStackDropped = NO;
  } else if (_clearScreen) {
    // to clear config from screen after swipe back
    [self clearConfigForScreen:screen];
    _clearScreen = NO;
  }
}

- (void)clearConfigForScreen:(ABI50_0_0REAUIView *)screen
{
  ABI50_0_0REANodeFind(screen, ^int(id<ABI50_0_0RCTComponent> _Nonnull view) {
    [self clearAllSharedConfigsForViewTag:view.ABI50_0_0ReactTag];
    return false;
  });
}

@end
