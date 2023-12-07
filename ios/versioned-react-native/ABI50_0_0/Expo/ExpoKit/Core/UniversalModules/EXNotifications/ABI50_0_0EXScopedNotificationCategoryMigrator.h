// Copyright 2021-present 650 Industries. All rights reserved.

#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationsDelegate.h>
#import <ABI50_0_0EXNotifications/ABI50_0_0EXNotificationCategoriesModule.h>

@interface ABI50_0_0EXScopedNotificationCategoryMigrator : NSObject <ABI50_0_0EXNotificationsDelegate>

+ (void)unscopeLegacyCategoryIdentifiersForProjectWithScopeKey:(NSString *)scopeKey;
+ (void)migrateLegacyScopedCategoryIdentifiersForProjectWithScopeKey:(NSString *)scopeKey;

@end
