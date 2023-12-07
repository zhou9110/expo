/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <ABI50_0_0yoga/debug/ABI50_0_0Log.h>

#ifdef ANDROID
#include <android/log.h>
#endif

namespace ABI50_0_0facebook::yoga {

namespace {

void vlog(
    const yoga::Config* config,
    const yoga::Node* node,
    LogLevel level,
    const char* format,
    va_list args) {
  if (config == nullptr) {
    getDefaultLogger()(nullptr, node, unscopedEnum(level), format, args);
  } else {
    config->log(node, level, format, args);
  }
}
} // namespace

void log(LogLevel level, const char* format, ...) noexcept {
  va_list args;
  va_start(args, format);
  vlog(nullptr, nullptr, level, format, args);
  va_end(args);
}

void log(
    const yoga::Node* node,
    LogLevel level,
    const char* format,
    ...) noexcept {
  va_list args;
  va_start(args, format);
  vlog(
      node == nullptr ? nullptr : node->getConfig(), node, level, format, args);
  va_end(args);
}

void log(
    const yoga::Config* config,
    LogLevel level,
    const char* format,
    ...) noexcept {
  va_list args;
  va_start(args, format);
  vlog(config, nullptr, level, format, args);
  va_end(args);
}

ABI50_0_0YGLogger getDefaultLogger() {
  return [](const ABI50_0_0YGConfigConstRef /*config*/,
            const ABI50_0_0YGNodeConstRef /*node*/,
            ABI50_0_0YGLogLevel level,
            const char* format,
            va_list args) -> int {
#ifdef ANDROID
    int androidLevel = ABI50_0_0YGLogLevelDebug;
    switch (level) {
      case ABI50_0_0YGLogLevelFatal:
        androidLevel = ANDROID_LOG_FATAL;
        break;
      case ABI50_0_0YGLogLevelError:
        androidLevel = ANDROID_LOG_ERROR;
        break;
      case ABI50_0_0YGLogLevelWarn:
        androidLevel = ANDROID_LOG_WARN;
        break;
      case ABI50_0_0YGLogLevelInfo:
        androidLevel = ANDROID_LOG_INFO;
        break;
      case ABI50_0_0YGLogLevelDebug:
        androidLevel = ANDROID_LOG_DEBUG;
        break;
      case ABI50_0_0YGLogLevelVerbose:
        androidLevel = ANDROID_LOG_VERBOSE;
        break;
    }
    return __android_log_vprint(androidLevel, "yoga", format, args);
#else
    switch (level) {
      case ABI50_0_0YGLogLevelError:
      case ABI50_0_0YGLogLevelFatal:
        return vfprintf(stderr, format, args);
      case ABI50_0_0YGLogLevelWarn:
      case ABI50_0_0YGLogLevelInfo:
      case ABI50_0_0YGLogLevelDebug:
      case ABI50_0_0YGLogLevelVerbose:
      default:
        return vprintf(format, args);
    }
#endif
  };
}

} // namespace ABI50_0_0facebook::yoga
