#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>

#import "ABI50_0_0SkiaUIView.h"
#import <ABI50_0_0RNSkiaModule.h>

#include <utility>
#include <vector>

#import <ABI50_0_0RNSkManager.h>

@implementation ABI50_0_0SkiaUIView {
  std::shared_ptr<ABI50_0_0RNSkBaseiOSView> _impl;
  ABI50_0_0RNSkia::ABI50_0_0RNSkManager *_manager;
  ABI50_0_0RNSkia::ABI50_0_0RNSkDrawingMode _drawingMode;
  std::function<std::shared_ptr<ABI50_0_0RNSkBaseiOSView>(
      std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext>)>
      _factory;
  bool _debugMode;
  size_t _nativeId;
}

#pragma mark Initialization and destruction

- (instancetype)initWithManager:(ABI50_0_0RNSkia::ABI50_0_0RNSkManager *)manager
                        factory:
                            (std::function<std::shared_ptr<ABI50_0_0RNSkBaseiOSView>(
                                 std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext>)>)
                                factory {
  self = [super init];
  if (self) {
    [self initCommon:manager factory:factory];
  }
  // Listen to notifications about module invalidation
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(willInvalidateModules)
             name:ABI50_0_0RCTBridgeWillInvalidateModulesNotification
           object:nil];
  return self;
}

- (void)initCommon:(ABI50_0_0RNSkia::ABI50_0_0RNSkManager *)manager
           factory:(std::function<std::shared_ptr<ABI50_0_0RNSkBaseiOSView>(
                        std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext>)>)factory {
  _manager = manager;
  _nativeId = 0;
  _debugMode = false;
  _drawingMode = ABI50_0_0RNSkia::ABI50_0_0RNSkDrawingMode::Default;
  _factory = factory;
}

- (ABI50_0_0SkiaManager *)skiaManager {
  auto bridge = [ABI50_0_0RCTBridge currentBridge];
  auto skiaModule = (ABI50_0_0RNSkiaModule *)[bridge moduleForName:@"ABI50_0_0RNSkiaModule"];
  return [skiaModule manager];
}

- (void)willInvalidateModules {
  _impl = nullptr;
  _manager = nullptr;
}

#pragma mark Lifecycle

- (void)willMoveToSuperview:(UIView *)newWindow {
  if (newWindow == NULL) {
    // Remove implementation view when the parent view is not set
    if (_impl != nullptr) {
      [_impl->getLayer() removeFromSuperlayer];

      if (_nativeId != 0 && _manager != nullptr) {
        _manager->setSkiaView(_nativeId, nullptr);
      }

      _impl = nullptr;
    }
  } else {
    // Create implementation view when the parent view is set
    if (_impl == nullptr && _manager != nullptr) {
      _impl = _factory(_manager->getPlatformContext());
      if (_impl == nullptr) {
        throw std::runtime_error(
            "Expected Skia view implementation, got nullptr.");
      }
      [self.layer addSublayer:_impl->getLayer()];
      if (_nativeId != 0) {
        _manager->setSkiaView(_nativeId, _impl->getDrawView());
      }
      _impl->getDrawView()->setDrawingMode(_drawingMode);
      _impl->getDrawView()->setShowDebugOverlays(_debugMode);
    }
  }
}

- (void)dealloc {
  [self unregisterView];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:ABI50_0_0RCTBridgeWillInvalidateModulesNotification
              object:nil];
}

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (void)prepareForRecycle {
  [super prepareForRecycle];
  [self unregisterView];
}

- (void)finalizeUpdates:(ABI50_0_0RNComponentViewUpdateMask)updateMask {
  [super finalizeUpdates:updateMask];
  if (updateMask == ABI50_0_0RNComponentViewUpdateMaskAll) {
    // this flag is only set when the view is inserted and we want to set the
    // manager here since the view could be recycled or the app could be
    // refreshed and we would have a stale manager then
    _manager = [[self skiaManager] skManager].get();
  }
}
#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED

- (void)unregisterView {
  if (_manager != nullptr && _nativeId != 0) {
    _manager->unregisterSkiaView(_nativeId);
  }

  assert(_impl == nullptr);
}

#pragma Render

- (void)drawRect:(CGRect)rect {
  // We override drawRect to ensure we to direct rendering when the
  // underlying OS view needs to render:
  if (_impl != nullptr) {
    _impl->getDrawView()->renderImmediate();
  }
}

#pragma mark Layout

- (void)layoutSubviews {
  [super layoutSubviews];
  if (_impl != nullptr) {
    _impl->setSize(self.bounds.size.width, self.bounds.size.height);
  }
}

#pragma mark Properties

- (void)setDrawingMode:(std::string)mode {
  _drawingMode = mode.compare("continuous") == 0
                     ? ABI50_0_0RNSkia::ABI50_0_0RNSkDrawingMode::Continuous
                     : ABI50_0_0RNSkia::ABI50_0_0RNSkDrawingMode::Default;

  if (_impl != nullptr) {
    _impl->getDrawView()->setDrawingMode(_drawingMode);
  }
}

- (void)setDebugMode:(bool)debugMode {
  _debugMode = debugMode;
  if (_impl != nullptr) {
    _impl->getDrawView()->setShowDebugOverlays(debugMode);
  }
}

- (void)setNativeId:(size_t)nativeId {
  _nativeId = nativeId;

  if (_impl != nullptr) {
    _manager->registerSkiaView(nativeId, _impl->getDrawView());
  }
}

#pragma mark External API

- (std::shared_ptr<ABI50_0_0RNSkBaseiOSView>)impl {
  return _impl;
}

#pragma mark Touch handling

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self handleTouches:touches withEvent:event];
}

- (void)handleTouches:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  if (event.type == UIEventTypeTouches) {
    std::vector<ABI50_0_0RNSkia::ABI50_0_0RNSkTouchInfo> nextTouches;
    for (UITouch *touch in touches) {
      auto position = [touch preciseLocationInView:self];
      ABI50_0_0RNSkia::ABI50_0_0RNSkTouchInfo nextTouch;
      nextTouch.x = position.x;
      nextTouch.y = position.y;
      nextTouch.force = [touch force];
      nextTouch.id = [touch hash];
      auto phase = [touch phase];
      switch (phase) {
      case UITouchPhaseBegan:
        nextTouch.type = ABI50_0_0RNSkia::ABI50_0_0RNSkTouchInfo::TouchType::Start;
        break;
      case UITouchPhaseMoved:
        nextTouch.type = ABI50_0_0RNSkia::ABI50_0_0RNSkTouchInfo::TouchType::Active;
        break;
      case UITouchPhaseEnded:
        nextTouch.type = ABI50_0_0RNSkia::ABI50_0_0RNSkTouchInfo::TouchType::End;
        break;
      case UITouchPhaseCancelled:
        nextTouch.type = ABI50_0_0RNSkia::ABI50_0_0RNSkTouchInfo::TouchType::Cancelled;
        break;
      default:
        nextTouch.type = ABI50_0_0RNSkia::ABI50_0_0RNSkTouchInfo::TouchType::Active;
        break;
      }

      nextTouches.push_back(nextTouch);
    }
    if (_impl != nullptr) {
      _impl->getDrawView()->updateTouchState(nextTouches);
    }
  }
}

@end
