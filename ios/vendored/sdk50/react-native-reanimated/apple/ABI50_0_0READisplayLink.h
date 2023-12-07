#if !TARGET_OS_OSX

#import <QuartzCore/CADisplayLink.h>

typedef CADisplayLink ABI50_0_0READisplayLink;

#else // TARGET_OS_OSX [

#ifdef __cplusplus
extern "C" {
#endif

#import <ABI50_0_0React/ABI50_0_0RCTPlatformDisplayLink.h>

#ifdef __cplusplus
}
#endif

typedef ABI50_0_0RCTPlatformDisplayLink ABI50_0_0READisplayLink;

#endif // ] TARGET_OS_OSX
