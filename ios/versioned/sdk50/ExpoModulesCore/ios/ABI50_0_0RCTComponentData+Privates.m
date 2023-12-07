// Copyright 2021-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoModulesCore/ABI50_0_0RCTComponentData+Privates.h>
#import <ABI50_0_0React/ABI50_0_0RCTComponentData.h>

@implementation ABI50_0_0RCTComponentDataSwiftAdapter

- (nonnull instancetype)initWithManagerClass:(nonnull Class)managerClass
                                      bridge:(nonnull ABI50_0_0RCTBridge *)bridge
                             eventDispatcher:(nullable id<ABI50_0_0RCTEventDispatcherProtocol>)eventDispatcher
{
  return [super initWithManagerClass:managerClass bridge:bridge eventDispatcher:nil];
}

@end
