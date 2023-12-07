/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTMemoryUtils.h"

int ABI50_0_0RCTGetRetainCount(id _Nullable object)
{
  return object != nil ? CFGetRetainCount((__bridge CFTypeRef)object) - 1 : 0;
}

OBJC_EXPORT
void *objc_autoreleasePoolPush(void) __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

OBJC_EXPORT
void objc_autoreleasePoolPop(void *context) __OSX_AVAILABLE_STARTING(__MAC_10_7, __IPHONE_5_0);

static NSString *const kAutoreleasePoolContextStackKey = @"autorelease_pool_context_stack";

void ABI50_0_0RCTAutoReleasePoolPush(void)
{
  assert([NSThread isMainThread]);
  NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
  void *context = objc_autoreleasePoolPush();
  NSMutableArray<NSValue *> *contextStack = dictionary[kAutoreleasePoolContextStackKey];
  if (!contextStack) {
    contextStack = [NSMutableArray array];
    dictionary[kAutoreleasePoolContextStackKey] = contextStack;
  }
  [contextStack addObject:[NSValue valueWithPointer:context]];
}

void ABI50_0_0RCTAutoReleasePoolPop(void)
{
  assert([NSThread isMainThread]);
  NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
  NSMutableArray<NSValue *> *contextStack = dictionary[kAutoreleasePoolContextStackKey];
  assert(contextStack.count > 0);
  NSValue *lastContext = contextStack.lastObject;
  [contextStack removeLastObject];
  objc_autoreleasePoolPop(lastContext.pointerValue);
}
