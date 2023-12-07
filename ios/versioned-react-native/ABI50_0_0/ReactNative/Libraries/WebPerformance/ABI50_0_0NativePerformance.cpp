/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <memory>

#include <ABI50_0_0cxxreact/ABI50_0_0ReactMarker.h>
#include <ABI50_0_0jsi/ABI50_0_0instrumentation.h>
#include "ABI50_0_0NativePerformance.h"
#include "ABI50_0_0PerformanceEntryReporter.h"

#include "ABI50_0_0Plugins.h"

std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule> NativePerformanceModuleProvider(
    std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker> jsInvoker) {
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::NativePerformance>(
      std::move(jsInvoker));
}

namespace ABI50_0_0facebook::ABI50_0_0React {

NativePerformance::NativePerformance(std::shared_ptr<CallInvoker> jsInvoker)
    : ABI50_0_0NativePerformanceCxxSpec(std::move(jsInvoker)) {}

void NativePerformance::mark(
    jsi::Runtime& rt,
    std::string name,
    double startTime) {
  PerformanceEntryReporter::getInstance().mark(name, startTime);
}

void NativePerformance::measure(
    jsi::Runtime& rt,
    std::string name,
    double startTime,
    double endTime,
    std::optional<double> duration,
    std::optional<std::string> startMark,
    std::optional<std::string> endMark) {
  PerformanceEntryReporter::getInstance().measure(
      name, startTime, endTime, duration, startMark, endMark);
}

std::unordered_map<std::string, double> NativePerformance::getSimpleMemoryInfo(
    jsi::Runtime& rt) {
  auto heapInfo = rt.instrumentation().getHeapInfo(false);
  std::unordered_map<std::string, double> heapInfoToJs;
  for (auto& entry : heapInfo) {
    heapInfoToJs[entry.first] = static_cast<double>(entry.second);
  }
  return heapInfoToJs;
}

std::unordered_map<std::string, double>
NativePerformance::getABI50_0_0ReactNativeStartupTiming(jsi::Runtime& rt) {
  std::unordered_map<std::string, double> result;

  ABI50_0_0ReactMarker::StartupLogger& startupLogger =
      ABI50_0_0ReactMarker::StartupLogger::getInstance();
  if (!std::isnan(startupLogger.getAppStartupStartTime())) {
    result["startTime"] = startupLogger.getAppStartupStartTime();
  } else if (!std::isnan(startupLogger.getInitABI50_0_0ReactRuntimeStartTime())) {
    result["startTime"] = startupLogger.getInitABI50_0_0ReactRuntimeStartTime();
  }

  if (!std::isnan(startupLogger.getInitABI50_0_0ReactRuntimeStartTime())) {
    result["initializeRuntimeStart"] =
        startupLogger.getInitABI50_0_0ReactRuntimeStartTime();
  }

  if (!std::isnan(startupLogger.getRunJSBundleStartTime())) {
    result["executeJavaScriptBundleEntryPointStart"] =
        startupLogger.getRunJSBundleStartTime();
  }

  if (!std::isnan(startupLogger.getRunJSBundleEndTime())) {
    result["executeJavaScriptBundleEntryPointEnd"] =
        startupLogger.getRunJSBundleEndTime();
  }

  if (!std::isnan(startupLogger.getInitABI50_0_0ReactRuntimeEndTime())) {
    result["initializeRuntimeEnd"] = startupLogger.getInitABI50_0_0ReactRuntimeEndTime();
  }

  if (!std::isnan(startupLogger.getAppStartupEndTime())) {
    result["endTime"] = startupLogger.getAppStartupEndTime();
  }

  return result;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
