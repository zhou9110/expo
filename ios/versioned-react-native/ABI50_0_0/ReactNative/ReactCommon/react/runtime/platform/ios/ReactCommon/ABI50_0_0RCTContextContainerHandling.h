/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

@protocol ABI50_0_0RCTContextContainerHandling <NSObject>

- (void)didCreateContextContainer:(std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::ContextContainer>)contextContainer;

@end
