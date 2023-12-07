/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/ABI50_0_0renderer/mapbuffer/MapBuffer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

enum JSErrorHandlerKey : uint16_t {
  kFrameFileName = 0,
  kFrameMethodName = 1,
  kFrameLineNumber = 2,
  kFrameColumnNumber = 3,
  kAllStackFrames = 4,
  kErrorMessage = 5,
  kExceptionId = 6,
  kIsFatal = 7
};

class JsErrorHandler {
 public:
  using JsErrorHandlingFunc = std::function<void(MapBuffer errorMap)>;

  JsErrorHandler(JsErrorHandlingFunc jsErrorHandlingFunc);
  ~JsErrorHandler();

  void handleJsError(const jsi::JSError& error, bool isFatal);

 private:
  JsErrorHandlingFunc _jsErrorHandlingFunc;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
