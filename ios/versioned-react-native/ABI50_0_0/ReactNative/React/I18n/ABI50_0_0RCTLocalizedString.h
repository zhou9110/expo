/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if WITH_FBI18N

#import <FBI18n/FBI18nFbt.h>
#define ABI50_0_0RCTLocalizedString(string, description) FBT(string, description)

#else

#import <ABI50_0_0React/ABI50_0_0FBXXHashUtils.h>

#ifdef __cplusplus
extern "C" {
#endif

uint64_t FBcoreLocalexxHash48(const char *input, uint64_t length, uint64_t seed);
NSString *ABI50_0_0RCTLocalizedStringFromKey(uint64_t key, NSString *defaultValue);

#define ABI50_0_0RCTLocalizedStringKey(string, description) \
  FBcoreLocalexxHash48(string "|" description, strlen(string) + strlen(description) + 1, 0)

#define ABI50_0_0RCTLocalizedString(string, description) \
  ABI50_0_0RCTLocalizedStringFromKey(ABI50_0_0RCTLocalizedStringKey(string, description), @"" string)

#ifdef __cplusplus
}
#endif

#endif
