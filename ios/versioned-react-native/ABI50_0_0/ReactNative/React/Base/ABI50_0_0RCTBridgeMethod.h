/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <Foundation/Foundation.h>

@class ABI50_0_0RCTBridge;

typedef NS_ENUM(NSInteger, ABI50_0_0RCTFunctionType) {
  ABI50_0_0RCTFunctionTypeNormal,
  ABI50_0_0RCTFunctionTypePromise,
  ABI50_0_0RCTFunctionTypeSync,
};

static inline const char *ABI50_0_0RCTFunctionDescriptorFromType(ABI50_0_0RCTFunctionType type)
{
  switch (type) {
    case ABI50_0_0RCTFunctionTypeNormal:
      return "async";
    case ABI50_0_0RCTFunctionTypePromise:
      return "promise";
    case ABI50_0_0RCTFunctionTypeSync:
      return "sync";
  }
};

@protocol ABI50_0_0RCTBridgeMethod <NSObject>

@property (nonatomic, readonly) const char *JSMethodName;
@property (nonatomic, readonly) ABI50_0_0RCTFunctionType functionType;

- (id)invokeWithBridge:(ABI50_0_0RCTBridge *)bridge module:(id)module arguments:(NSArray *)arguments;

@end
