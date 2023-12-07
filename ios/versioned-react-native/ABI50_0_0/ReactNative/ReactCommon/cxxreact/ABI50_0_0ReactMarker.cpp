/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0ReactMarker.h"
#include <ABI50_0_0cxxreact/ABI50_0_0JSExecutor.h>

namespace ABI50_0_0facebook::ABI50_0_0React {
namespace ABI50_0_0ReactMarker {

#if __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wglobal-constructors"
#endif

LogTaggedMarker logTaggedMarkerImpl = nullptr;
LogTaggedMarker logTaggedMarkerBridgelessImpl = nullptr;

#if __clang__
#pragma clang diagnostic pop
#endif

void logMarker(const ABI50_0_0ReactMarkerId markerId) {
  logTaggedMarker(markerId, nullptr);
}

void logTaggedMarker(const ABI50_0_0ReactMarkerId markerId, const char* tag) {
  logTaggedMarkerImpl(markerId, tag);
}

void logMarkerBridgeless(const ABI50_0_0ReactMarkerId markerId) {
  logTaggedMarkerBridgeless(markerId, nullptr);
}

void logTaggedMarkerBridgeless(const ABI50_0_0ReactMarkerId markerId, const char* tag) {
  logTaggedMarkerBridgelessImpl(markerId, tag);
}

void logMarkerDone(const ABI50_0_0ReactMarkerId markerId, double markerTime) {
  StartupLogger::getInstance().logStartupEvent(markerId, markerTime);
}

StartupLogger& StartupLogger::getInstance() {
  static StartupLogger instance;
  return instance;
}

void StartupLogger::logStartupEvent(
    const ABI50_0_0ReactMarkerId markerId,
    double markerTime) {
  switch (markerId) {
    case ABI50_0_0ReactMarkerId::APP_STARTUP_START:
      if (std::isnan(appStartupStartTime)) {
        appStartupStartTime = markerTime;
      }
      return;

    case ABI50_0_0ReactMarkerId::APP_STARTUP_STOP:
      if (std::isnan(appStartupEndTime)) {
        appStartupEndTime = markerTime;
      }
      return;

    case ABI50_0_0ReactMarkerId::INIT_REACT_RUNTIME_START:
      if (std::isnan(initABI50_0_0ReactRuntimeStartTime)) {
        initABI50_0_0ReactRuntimeStartTime = markerTime;
      }
      return;

    case ABI50_0_0ReactMarkerId::INIT_REACT_RUNTIME_STOP:
      if (std::isnan(initABI50_0_0ReactRuntimeEndTime)) {
        initABI50_0_0ReactRuntimeEndTime = markerTime;
      }
      return;

    case ABI50_0_0ReactMarkerId::RUN_JS_BUNDLE_START:
      if (std::isnan(runJSBundleStartTime)) {
        runJSBundleStartTime = markerTime;
      }
      return;

    case ABI50_0_0ReactMarkerId::RUN_JS_BUNDLE_STOP:
      if (std::isnan(runJSBundleEndTime)) {
        runJSBundleEndTime = markerTime;
      }
      return;

    default:
      return;
  }
}

double StartupLogger::getAppStartupStartTime() {
  return appStartupStartTime;
}

double StartupLogger::getInitABI50_0_0ReactRuntimeStartTime() {
  return initABI50_0_0ReactRuntimeStartTime;
}

double StartupLogger::getInitABI50_0_0ReactRuntimeEndTime() {
  return initABI50_0_0ReactRuntimeEndTime;
}

double StartupLogger::getRunJSBundleStartTime() {
  return runJSBundleStartTime;
}

double StartupLogger::getRunJSBundleEndTime() {
  return runJSBundleEndTime;
}

double StartupLogger::getAppStartupEndTime() {
  return appStartupEndTime;
}

} // namespace ABI50_0_0ReactMarker
} // namespace ABI50_0_0facebook::ABI50_0_0React
