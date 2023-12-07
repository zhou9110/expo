/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTDefines.h>

ABI50_0_0RCT_EXTERN_C_BEGIN

int ABI50_0_0RCTGetRetainCount(id _Nullable object);

void ABI50_0_0RCTAutoReleasePoolPush(void);
void ABI50_0_0RCTAutoReleasePoolPop(void);

ABI50_0_0RCT_EXTERN_C_END
