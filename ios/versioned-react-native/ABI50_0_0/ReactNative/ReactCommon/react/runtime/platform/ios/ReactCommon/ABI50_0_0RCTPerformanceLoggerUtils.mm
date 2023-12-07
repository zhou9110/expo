/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "ABI50_0_0RCTPerformanceLoggerUtils.h"

#import <ABI50_0_0React/ABI50_0_0RCTPerformanceLogger.h>
#import <ABI50_0_0cxxreact/ABI50_0_0ReactMarker.h>

using namespace ABI50_0_0facebook::ABI50_0_0React;

static void mapABI50_0_0ReactMarkerToPerformanceLogger(
    const ABI50_0_0ReactMarker::ABI50_0_0ReactMarkerId markerId,
    ABI50_0_0RCTPerformanceLogger *performanceLogger)
{
  switch (markerId) {
    case ABI50_0_0ReactMarker::APP_STARTUP_START:
      [performanceLogger markStartForTag:ABI50_0_0RCTPLAppStartup];
      break;
    case ABI50_0_0ReactMarker::APP_STARTUP_STOP:
      [performanceLogger markStopForTag:ABI50_0_0RCTPLAppStartup];
      break;
    case ABI50_0_0ReactMarker::INIT_REACT_RUNTIME_START:
      [performanceLogger markStartForTag:ABI50_0_0RCTPLInitABI50_0_0ReactRuntime];
      break;
    case ABI50_0_0ReactMarker::INIT_REACT_RUNTIME_STOP:
      [performanceLogger markStopForTag:ABI50_0_0RCTPLInitABI50_0_0ReactRuntime];
      break;
    case ABI50_0_0ReactMarker::RUN_JS_BUNDLE_START:
      [performanceLogger markStartForTag:ABI50_0_0RCTPLScriptExecution];
      break;
    case ABI50_0_0ReactMarker::RUN_JS_BUNDLE_STOP:
      [performanceLogger markStopForTag:ABI50_0_0RCTPLScriptExecution];
      break;
    case ABI50_0_0ReactMarker::NATIVE_REQUIRE_START:
      [performanceLogger appendStartForTag:ABI50_0_0RCTPLRAMNativeRequires];
      break;
    case ABI50_0_0ReactMarker::NATIVE_REQUIRE_STOP:
      [performanceLogger appendStopForTag:ABI50_0_0RCTPLRAMNativeRequires];
      [performanceLogger addValue:1 forTag:ABI50_0_0RCTPLRAMNativeRequiresCount];
      break;
    case ABI50_0_0ReactMarker::NATIVE_MODULE_SETUP_START:
      [performanceLogger markStartForTag:ABI50_0_0RCTPLNativeModuleSetup];
      break;
    case ABI50_0_0ReactMarker::NATIVE_MODULE_SETUP_STOP:
      [performanceLogger markStopForTag:ABI50_0_0RCTPLNativeModuleSetup];
      break;
    case ABI50_0_0ReactMarker::ABI50_0_0REACT_INSTANCE_INIT_START:
      [performanceLogger markStartForTag:ABI50_0_0RCTPLABI50_0_0ReactInstanceInit];
      break;
    case ABI50_0_0ReactMarker::ABI50_0_0REACT_INSTANCE_INIT_STOP:
      [performanceLogger markStopForTag:ABI50_0_0RCTPLABI50_0_0ReactInstanceInit];
      break;
    case ABI50_0_0ReactMarker::CREATE_REACT_CONTEXT_STOP:
    case ABI50_0_0ReactMarker::JS_BUNDLE_STRING_CONVERT_START:
    case ABI50_0_0ReactMarker::JS_BUNDLE_STRING_CONVERT_STOP:
    case ABI50_0_0ReactMarker::REGISTER_JS_SEGMENT_START:
    case ABI50_0_0ReactMarker::REGISTER_JS_SEGMENT_STOP:
      // These are not used on iOS.
      break;
  }
}

void registerPerformanceLoggerHooks(ABI50_0_0RCTPerformanceLogger *performanceLogger)
{
  __weak ABI50_0_0RCTPerformanceLogger *weakPerformanceLogger = performanceLogger;
  ABI50_0_0ReactMarker::logTaggedMarkerBridgelessImpl = [weakPerformanceLogger](
                                                   const ABI50_0_0ReactMarker::ABI50_0_0ReactMarkerId markerId, const char *tag) {
    mapABI50_0_0ReactMarkerToPerformanceLogger(markerId, weakPerformanceLogger);
  };
}
