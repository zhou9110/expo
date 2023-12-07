/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTSurfacePresenterStub.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#import "ABI50_0_0RCTBridge.h"
#import "ABI50_0_0RCTBridgeModule.h"

@implementation ABI50_0_0RCTViewRegistry {
  ABI50_0_0RCTBridgelessComponentViewProvider _bridgelessComponentViewProvider;
  __weak ABI50_0_0RCTBridge *_bridge;
}

- (void)setBridge:(ABI50_0_0RCTBridge *)bridge
{
  _bridge = bridge;
}

- (void)setBridgelessComponentViewProvider:(ABI50_0_0RCTBridgelessComponentViewProvider)bridgelessComponentViewProvider
{
  _bridgelessComponentViewProvider = bridgelessComponentViewProvider;
}

- (UIView *)viewForABI50_0_0ReactTag:(NSNumber *)ABI50_0_0ReactTag
{
  UIView *view = nil;

  ABI50_0_0RCTBridge *bridge = _bridge;
  if (bridge) {
    view = [bridge.uiManager viewForABI50_0_0ReactTag:ABI50_0_0ReactTag];
  }

  if (view == nil && _bridgelessComponentViewProvider) {
    view = _bridgelessComponentViewProvider(ABI50_0_0ReactTag);
  }

  return view;
}

- (void)addUIBlock:(ABI50_0_0RCTViewRegistryUIBlock)block
{
  if (!block) {
    return;
  }

  __weak __typeof(self) weakSelf = self;
  if (_bridge) {
    [_bridge.uiManager addUIBlock:^(ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
      __typeof(self) strongSelf = weakSelf;
      if (strongSelf) {
        block(strongSelf);
      }
    }];
  } else {
    ABI50_0_0RCTExecuteOnMainQueue(^{
      __typeof(self) strongSelf = weakSelf;
      if (strongSelf) {
        block(strongSelf);
      }
    });
  }
}

@end
