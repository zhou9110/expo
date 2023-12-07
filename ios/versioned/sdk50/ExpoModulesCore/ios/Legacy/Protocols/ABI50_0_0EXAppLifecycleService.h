// Copyright © 2018 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXAppLifecycleListener.h>

@protocol ABI50_0_0EXAppLifecycleService <NSObject>

- (void)registerAppLifecycleListener:(id<ABI50_0_0EXAppLifecycleListener>)listener;
- (void)unregisterAppLifecycleListener:(id<ABI50_0_0EXAppLifecycleListener>)listener;
- (void)setAppStateToBackground;
- (void)setAppStateToForeground;

@end
