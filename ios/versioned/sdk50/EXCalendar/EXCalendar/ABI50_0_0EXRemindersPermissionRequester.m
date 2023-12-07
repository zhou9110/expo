#import <ABI50_0_0EXCalendar/ABI50_0_0EXRemindersPermissionRequester.h>
#import <EventKit/EventKit.h>


@implementation ABI50_0_0EXRemindersPermissionRequester

+ (NSString *)permissionType
{
  return @"reminders";
}

- (NSDictionary *)getPermissions
{
  ABI50_0_0EXPermissionStatus status;
  EKAuthorizationStatus permissions;
  
  NSString *description;
  if (@available(iOS 17, *)) {
    description = @"NSRemindersFullAccessUsageDescription";
  } else {
    description = @"NSRemindersUsageDescription";
  }
  
  NSString *remindersUsageDescription = [[NSBundle mainBundle] objectForInfoDictionaryKey:description];
  
  if (!remindersUsageDescription) {
    NSString *message = [NSString stringWithFormat:@"This app is missing %@, so reminders methods will fail. Add this key to your bundle's Info.plist.", description];
    ABI50_0_0EXFatal(ABI50_0_0EXErrorWithMessage(message));
    permissions = EKAuthorizationStatusDenied;
  } else {
    permissions = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
  }
  
  switch (permissions) {
    case EKAuthorizationStatusAuthorized:
      status = ABI50_0_0EXPermissionStatusGranted;
      break;
    case EKAuthorizationStatusRestricted:
    case EKAuthorizationStatusDenied:
      status = ABI50_0_0EXPermissionStatusDenied;
      break;
    case EKAuthorizationStatusNotDetermined:
      status = ABI50_0_0EXPermissionStatusUndetermined;
      break;
  }
  
  return @{
           @"status": @(status)
          };
}

- (void)requestPermissionsWithResolver:(ABI50_0_0EXPromiseResolveBlock)resolve rejecter:(ABI50_0_0EXPromiseRejectBlock)reject
{
  EKEventStore *eventStore = [[EKEventStore alloc] init];
  ABI50_0_0EX_WEAKIFY(self)
#if defined(__IPHONE_17_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_17_0
  if (@available(iOS 17.0, *)) {
    [eventStore requestFullAccessToRemindersWithCompletion:^(BOOL granted, NSError * _Nullable error) {
      ABI50_0_0EX_STRONGIFY(self)
      if (error && error.code != 100) {
        reject(@"E_CALENDAR_ERROR_UNKNOWN", error.localizedDescription, error);
      } else {
        resolve([self getPermissions]);
      }
    }];
  } else {
    [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
      ABI50_0_0EX_STRONGIFY(self)
      // Error code 100 is a when the user denies permission; in that case we don't want to reject.
      if (error && error.code != 100) {
        reject(@"E_REMINDERS_ERROR_UNKNOWN", error.localizedDescription, error);
      } else {
        resolve([self getPermissions]);
      }
    }];
  }
#else
  [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
    ABI50_0_0EX_STRONGIFY(self)
    // Error code 100 is a when the user denies permission; in that case we don't want to reject.
    if (error && error.code != 100) {
      reject(@"E_REMINDERS_ERROR_UNKNOWN", error.localizedDescription, error);
    } else {
      resolve([self getPermissions]);
    }
  }];
#endif
}

@end
