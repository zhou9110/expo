// Copyright 2018-present 650 Industries. All rights reserved.

#if __has_include(<ABI50_0_0EXErrorRecovery/ABI50_0_0EXErrorRecoveryModule.h>)
#import <ABI50_0_0EXErrorRecovery/ABI50_0_0EXErrorRecoveryModule.h>

@interface ABI50_0_0EXScopedErrorRecoveryModule : ABI50_0_0EXErrorRecoveryModule

- (instancetype)initWithScopeKey:(NSString *)scopeKey;

@end

#endif
