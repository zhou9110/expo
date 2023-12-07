/**
 * Copyright (c) 2015-present, Horcrux.
 * All rights reserved.
 *
 * This source code is licensed under the MIT-style license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import "ABI50_0_0RNSVGLength.h"
#import "ABI50_0_0RNSVGRenderable.h"
#import "ABI50_0_0RNSVGVBMOS.h"

#import <ABI50_0_0React/ABI50_0_0RCTImageSource.h>

#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import <ABI50_0_0React/ABI50_0_0RCTImageResponseDelegate.h>
#endif

@interface ABI50_0_0RNSVGImage : ABI50_0_0RNSVGRenderable
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
                        <ABI50_0_0RCTImageResponseDelegate>
#endif

@property (nonatomic, weak) ABI50_0_0RCTBridge *bridge;
@property (nonatomic, assign) ABI50_0_0RCTImageSource *src;
@property (nonatomic, strong) ABI50_0_0RNSVGLength *x;
@property (nonatomic, strong) ABI50_0_0RNSVGLength *y;
@property (nonatomic, strong) ABI50_0_0RNSVGLength *imagewidth;
@property (nonatomic, strong) ABI50_0_0RNSVGLength *imageheight;
@property (nonatomic, strong) NSString *align;
@property (nonatomic, assign) ABI50_0_0RNSVGVBMOS meetOrSlice;

@end
