#ifndef ABI50_0_0REAKeyboardEventManager_h
#define ABI50_0_0REAKeyboardEventManager_h

#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>

typedef void (^KeyboardEventListenerBlock)(int keyboardState, int height);

@interface ABI50_0_0REAKeyboardEventObserver : NSObject

- (instancetype)init;
- (int)subscribeForKeyboardEvents:(KeyboardEventListenerBlock)listener;
- (void)unsubscribeFromKeyboardEvents:(int)listenerId;

@end

#endif /* ABI50_0_0REAKeyboardEventManager_h */
