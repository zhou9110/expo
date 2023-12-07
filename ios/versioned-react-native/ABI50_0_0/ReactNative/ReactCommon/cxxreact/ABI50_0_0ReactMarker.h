/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <cmath>

#ifdef __APPLE__
#include <functional>
#endif

namespace ABI50_0_0facebook::ABI50_0_0React {
namespace ABI50_0_0ReactMarker {

enum ABI50_0_0ReactMarkerId {
  APP_STARTUP_START,
  APP_STARTUP_STOP,
  INIT_REACT_RUNTIME_START,
  INIT_REACT_RUNTIME_STOP,
  NATIVE_REQUIRE_START,
  NATIVE_REQUIRE_STOP,
  RUN_JS_BUNDLE_START,
  RUN_JS_BUNDLE_STOP,
  CREATE_REACT_CONTEXT_STOP,
  JS_BUNDLE_STRING_CONVERT_START,
  JS_BUNDLE_STRING_CONVERT_STOP,
  NATIVE_MODULE_SETUP_START,
  NATIVE_MODULE_SETUP_STOP,
  REGISTER_JS_SEGMENT_START,
  REGISTER_JS_SEGMENT_STOP,
  ABI50_0_0REACT_INSTANCE_INIT_START,
  ABI50_0_0REACT_INSTANCE_INIT_STOP
};

#ifdef __APPLE__
using LogTaggedMarker =
    std::function<void(const ABI50_0_0ReactMarkerId, const char* tag)>; // Bridge only
using LogTaggedMarkerBridgeless =
    std::function<void(const ABI50_0_0ReactMarkerId, const char* tag)>;
#else
typedef void (
    *LogTaggedMarker)(const ABI50_0_0ReactMarkerId, const char* tag); // Bridge only
typedef void (*LogTaggedMarkerBridgeless)(const ABI50_0_0ReactMarkerId, const char* tag);
#endif

#ifndef ABI50_0_0RN_EXPORT
#define ABI50_0_0RN_EXPORT __attribute__((visibility("default")))
#endif

extern ABI50_0_0RN_EXPORT LogTaggedMarker logTaggedMarkerImpl; // Bridge only
extern ABI50_0_0RN_EXPORT LogTaggedMarker logTaggedMarkerBridgelessImpl;

extern ABI50_0_0RN_EXPORT void logMarker(const ABI50_0_0ReactMarkerId markerId); // Bridge only
extern ABI50_0_0RN_EXPORT void logTaggedMarker(
    const ABI50_0_0ReactMarkerId markerId,
    const char* tag); // Bridge only
extern ABI50_0_0RN_EXPORT void logMarkerBridgeless(const ABI50_0_0ReactMarkerId markerId);
extern ABI50_0_0RN_EXPORT void logTaggedMarkerBridgeless(
    const ABI50_0_0ReactMarkerId markerId,
    const char* tag);

struct ABI50_0_0ReactMarkerEvent {
  const ABI50_0_0ReactMarkerId markerId;
  const char* tag;
  double time;
};

class ABI50_0_0RN_EXPORT StartupLogger {
 public:
  static StartupLogger& getInstance();

  void logStartupEvent(const ABI50_0_0ReactMarkerId markerName, double markerTime);
  double getAppStartupStartTime();
  double getInitABI50_0_0ReactRuntimeStartTime();
  double getInitABI50_0_0ReactRuntimeEndTime();
  double getRunJSBundleStartTime();
  double getRunJSBundleEndTime();
  double getAppStartupEndTime();

 private:
  StartupLogger() = default;
  StartupLogger(const StartupLogger&) = delete;
  StartupLogger& operator=(const StartupLogger&) = delete;

  double appStartupStartTime = std::nan("");
  double appStartupEndTime = std::nan("");
  double initABI50_0_0ReactRuntimeStartTime = std::nan("");
  double initABI50_0_0ReactRuntimeEndTime = std::nan("");
  double runJSBundleStartTime = std::nan("");
  double runJSBundleEndTime = std::nan("");
};

// When the marker got logged from the platform, it will notify here. This is
// used to collect ABI50_0_0React markers that are logged in the platform instead of in
// C++.
extern ABI50_0_0RN_EXPORT void logMarkerDone(
    const ABI50_0_0ReactMarkerId markerId,
    double markerTime);

} // namespace ABI50_0_0ReactMarker
} // namespace ABI50_0_0facebook::ABI50_0_0React
