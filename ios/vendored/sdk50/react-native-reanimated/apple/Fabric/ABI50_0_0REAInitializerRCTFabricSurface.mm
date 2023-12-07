#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED

#import <ABI50_0_0React/ABI50_0_0RCTSurface.h>
#import <ABI50_0_0React/ABI50_0_0RCTSurfaceView.h>
#import <memory>

#import <ABI50_0_0RNReanimated/ABI50_0_0REAInitializerRCTFabricSurface.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0REAModule.h>

@implementation ABI50_0_0REAInitializerRCTFabricSurface {
  std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler> _surfaceHandler;
  int _tag;
  ABI50_0_0RCTSurface *_surface;
}

- (instancetype)init
{
  if (self = [super init]) {
    _tag = -1;
    _surface = [[ABI50_0_0RCTSurface alloc] init];
    _surfaceHandler = std::make_shared<ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler>("ABI50_0_0REASurface", _tag);
  }
  return self;
}

- (NSNumber *)rootViewTag
{
  return @(_tag);
}

- (NSInteger)rootTag
{
  return (NSInteger)_tag;
}

- (void)start
{
  // this is only needed method, the rest of them is just for prevent null pointer exceptions
  [_reaModule installReanimatedAfterReload];
}

- (ABI50_0_0facebook::ABI50_0_0React::SurfaceHandler const &)surfaceHandler
{
  return *_surfaceHandler.get();
}

- (void)setMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize
{
}

- (void)setMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize viewportOffset:(CGPoint)viewportOffset
{
}

- (void)stop
{
}

- (CGSize)sizeThatFitsMinimumSize:(CGSize)minimumSize maximumSize:(CGSize)maximumSize
{
  CGSize size{0, 0};
  return size;
}

- (nonnull ABI50_0_0RCTSurfaceView *)view
{
  // This method should never be called.
  react_native_assert(false);
  return nullptr;
}

@end

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
