/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <ABI50_0_0React/ABI50_0_0RCTComponentViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * Holds a native view class and a set of attributes associated with it.
 */
class ABI50_0_0RCTComponentViewClassDescriptor final {
 public:
  /*
   * Associated (and owned) native view class.
   */
  Class<ABI50_0_0RCTComponentViewProtocol> viewClass;

  /*
   * Indicates a requirement to call on the view methods from
   * `ABI50_0_0RCTMountingTransactionObserving` protocol.
   */
  bool observesMountingTransactionWillMount{false};
  bool observesMountingTransactionDidMount{false};
};

NS_ASSUME_NONNULL_END
