// Copyright 2018-present 650 Industries. All rights reserved.

#if __has_include(<ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsHandlerModule.h>)

#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsHandlerModule.h>

NS_ASSUME_NONNULL_BEGIN

@interface ABI50_0_0EXScopedNotificationsHandlerModule : ABI50_0_0EXNotificationsHandlerModule

- (instancetype)initWithScopeKey:(NSString *)scopeKey;

@end

NS_ASSUME_NONNULL_END

#endif
