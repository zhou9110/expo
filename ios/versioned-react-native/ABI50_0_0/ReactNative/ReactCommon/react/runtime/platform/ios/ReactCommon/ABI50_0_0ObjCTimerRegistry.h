/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTTiming.h>
#import <ABI50_0_0React/runtime/ABI50_0_0PlatformTimerRegistry.h>
#import <ABI50_0_0React/runtime/ABI50_0_0TimerManager.h>

@interface ABI50_0_0RCTJSTimerExecutor : NSObject <ABI50_0_0RCTTimingDelegate>

- (void)setTimerManager:(std::weak_ptr<ABI50_0_0facebook::ABI50_0_0React::TimerManager>)timerManager;

@end

class ObjCTimerRegistry : public ABI50_0_0facebook::ABI50_0_0React::PlatformTimerRegistry {
 public:
  ObjCTimerRegistry();
  void createTimer(uint32_t timerID, double delayMS) override;
  void deleteTimer(uint32_t timerID) override;
  void createRecurringTimer(uint32_t timerID, double delayMS) override;
  void setTimerManager(std::weak_ptr<ABI50_0_0facebook::ABI50_0_0React::TimerManager> timerManager);
  ABI50_0_0RCTTiming *_Null_unspecified timing;

 private:
  ABI50_0_0RCTJSTimerExecutor *_Null_unspecified jsTimerExecutor_;
  double toSeconds(double ms);
};
