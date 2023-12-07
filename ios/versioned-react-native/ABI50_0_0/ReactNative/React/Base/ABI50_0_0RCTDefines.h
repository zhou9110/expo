/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#if __OBJC__
#import <Foundation/Foundation.h>
#endif

/**
 * Make global functions usable in C++
 */
#if defined(__cplusplus)
#define ABI50_0_0RCT_EXTERN extern "C" __attribute__((visibility("default")))
#define ABI50_0_0RCT_EXTERN_C_BEGIN extern "C" {
#define ABI50_0_0RCT_EXTERN_C_END }
#else
#define ABI50_0_0RCT_EXTERN extern __attribute__((visibility("default")))
#define ABI50_0_0RCT_EXTERN_C_BEGIN
#define ABI50_0_0RCT_EXTERN_C_END
#endif

/**
 * The ABI50_0_0RCT_DEBUG macro can be used to exclude error checking and logging code
 * from release builds to improve performance and reduce binary size.
 */
#ifndef ABI50_0_0RCT_DEBUG
#if DEBUG
#define ABI50_0_0RCT_DEBUG 1
#else
#define ABI50_0_0RCT_DEBUG 0
#endif
#endif

/**
 * The ABI50_0_0RCT_DEV macro can be used to enable or disable development tools
 * such as the debug executors, dev menu, red box, etc.
 */
#ifndef ABI50_0_0RCT_DEV
#if DEBUG
#define ABI50_0_0RCT_DEV 1
#else
#define ABI50_0_0RCT_DEV 0
#endif
#endif

/**
 * ABI50_0_0RCT_REMOTE_PROFILE: ABI50_0_0RCT_PROFILE + ABI50_0_0RCT_ENABLE_INSPECTOR + enable the
 * connectivity functionality to control the profiler remotely, such as via Chrome DevTools or
 * Flipper.
 */
#ifndef ABI50_0_0RCT_REMOTE_PROFILE
#define ABI50_0_0RCT_REMOTE_PROFILE ABI50_0_0RCT_DEV
#endif

/**
 * Enable the code to support making calls to the underlying sampling profiler mechanism.
 */
#ifndef ABI50_0_0RCT_PROFILE
#define ABI50_0_0RCT_PROFILE ABI50_0_0RCT_REMOTE_PROFILE
#endif

#ifndef ABI50_0_0RCT_ENABLE_INSPECTOR
#if (ABI50_0_0RCT_DEV || ABI50_0_0RCT_REMOTE_PROFILE) && __has_include(<ABI50_0_0React/ABI50_0_0RCTInspectorDevServerHelper.h>)
#define ABI50_0_0RCT_ENABLE_INSPECTOR 1
#else
#define ABI50_0_0RCT_ENABLE_INSPECTOR 0
#endif
#endif

/**
 * Sanity check that these compile-time flags are compatible. ABI50_0_0RCT_REMOTE_PROFILE requires ABI50_0_0RCT_PROFILE and
 * ABI50_0_0RCT_ENABLE_INSPECTOR
 */
#if ABI50_0_0RCT_REMOTE_PROFILE
#if !ABI50_0_0RCT_PROFILE
#error "ABI50_0_0RCT_PROFILE needs to be set to fulfill ABI50_0_0RCT_REMOTE_PROFILE"
#endif // ABI50_0_0RCT_PROFILE
#if !ABI50_0_0RCT_ENABLE_INSPECTOR
#error "ABI50_0_0RCT_ENABLE_INSPECTOR needs to be set to fulfill ABI50_0_0RCT_REMOTE_PROFILE"
#endif // ABI50_0_0RCT_ENABLE_INSPECTOR
#endif // ABI50_0_0RCT_REMOTE_PROFILE

/**
 * ABI50_0_0RCT_DEV_MENU can be used to toggle the dev menu separately from ABI50_0_0RCT_DEV.
 * By default though, it will inherit from ABI50_0_0RCT_DEV.
 */
#ifndef ABI50_0_0RCT_DEV_MENU
#define ABI50_0_0RCT_DEV_MENU ABI50_0_0RCT_DEV
#endif

/**
 * Controls for the core packgaer loading functionality
 * By default, this inherits from ABI50_0_0RCT_DEV_MENU but it also gives the capability to
 * enable the packager functionality without the rest of the dev tools from ABI50_0_0RCT_DEV_MENU
 */
#ifndef ABI50_0_0RCT_ENABLE_LOADING_FROM_PACKAGER
#define ABI50_0_0RCT_ENABLE_LOADING_FROM_PACKAGER ABI50_0_0RCT_DEV_MENU
#endif

#ifndef ABI50_0_0RCT_DEV_SETTINGS_ENABLE_PACKAGER_CONNECTION
#if ABI50_0_0RCT_DEV && (__has_include("ABI50_0_0RCTPackagerConnection.h") || __has_include(<ABI50_0_0React/ABI50_0_0RCTPackagerConnection.h>))
#define ABI50_0_0RCT_DEV_SETTINGS_ENABLE_PACKAGER_CONNECTION 1
#else
#define ABI50_0_0RCT_DEV_SETTINGS_ENABLE_PACKAGER_CONNECTION 0
#endif
#endif

#if ABI50_0_0RCT_DEV
#define ABI50_0_0RCT_IF_DEV(...) __VA_ARGS__
#else
#define ABI50_0_0RCT_IF_DEV(...)
#endif

#ifndef ABI50_0_0RCT_PROFILE
#define ABI50_0_0RCT_PROFILE ABI50_0_0RCT_DEV
#endif

/**
 * Add the default Metro packager port number
 */
#ifndef ABI50_0_0RCT_METRO_PORT
#define ABI50_0_0RCT_METRO_PORT 8081
#else
// test if ABI50_0_0RCT_METRO_PORT is empty
#define ABI50_0_0RCT_METRO_PORT_DO_EXPAND(VAL) VAL##1
#define ABI50_0_0RCT_METRO_PORT_EXPAND(VAL) ABI50_0_0RCT_METRO_PORT_DO_EXPAND(VAL)
#if !defined(ABI50_0_0RCT_METRO_PORT) || (ABI50_0_0RCT_METRO_PORT_EXPAND(ABI50_0_0RCT_METRO_PORT) == 1)
// Only here if ABI50_0_0RCT_METRO_PORT is not defined
// OR ABI50_0_0RCT_METRO_PORT is the empty string
#undef ABI50_0_0RCT_METRO_PORT
#define ABI50_0_0RCT_METRO_PORT 8081
#endif
#endif

/**
 * Add the default packager name
 */
#ifndef ABI50_0_0RCT_PACKAGER_NAME
#define ABI50_0_0RCT_PACKAGER_NAME @"Metro"
#endif

/**
 * By default, only raise an NSAssertion in debug mode
 * (custom assert functions will still be called).
 */
#ifndef ABI50_0_0RCT_NSASSERT
#define ABI50_0_0RCT_NSASSERT ABI50_0_0RCT_DEBUG
#endif

/**
 * Concat two literals. Supports macro expansions,
 * e.g. ABI50_0_0RCT_CONCAT(foo, __FILE__).
 */
#define ABI50_0_0RCT_CONCAT2(A, B) A##B
#define ABI50_0_0RCT_CONCAT(A, B) ABI50_0_0RCT_CONCAT2(A, B)

/**
 * This attribute is used for static analysis.
 */
#if !defined ABI50_0_0RCT_DYNAMIC
#if __has_attribute(objc_dynamic)
#define ABI50_0_0RCT_DYNAMIC __attribute__((objc_dynamic))
#else
#define ABI50_0_0RCT_DYNAMIC
#endif
#endif

/**
 * Throw an assertion for unimplemented methods.
 */
#define ABI50_0_0RCT_NOT_IMPLEMENTED(method)                                                                     \
  _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Wmissing-method-return-type\"") \
      _Pragma("clang diagnostic ignored \"-Wunused-parameter\"")                                        \
          ABI50_0_0RCT_EXTERN NSException *_ABI50_0_0RCTNotImplementedException(SEL, Class);                              \
  method NS_UNAVAILABLE                                                                                 \
  {                                                                                                     \
    @throw _ABI50_0_0RCTNotImplementedException(_cmd, [self class]);                                             \
  }                                                                                                     \
  _Pragma("clang diagnostic pop")

/**
 * Controls for activating the new architecture without the legacy system.
 * Note: this is work in progress.
 */
#ifdef ABI50_0_0REACT_NATIVE_FORCE_NEW_ARCHITECTURE
#define ABI50_0_0RCT_ONLY_NEW_ARCHITECTURE 1
#else
#define ABI50_0_0RCT_ONLY_NEW_ARCHITECTURE 0
#endif

#define ABI50_0_0EX_REMOVE_VERSION(string) (([string hasPrefix:@"ABI50_0_0"]) ? [string stringByReplacingCharactersInRange:(NSRange){0,@"ABI50_0_0".length} withString:@""] : string)
