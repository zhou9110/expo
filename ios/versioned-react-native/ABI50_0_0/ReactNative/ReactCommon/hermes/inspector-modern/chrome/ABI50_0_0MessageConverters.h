/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <regex>
#include <string>
#include <vector>

#include <hermes/ABI50_0_0DebuggerAPI.h>
#include <hermes/ABI50_0_0hermes.h>
#include <hermes/inspector-modern/chrome/ABI50_0_0MessageTypes.h>
#include <hermes/inspector-modern/chrome/ABI50_0_0RemoteObjectsTable.h>
#include <ABI50_0_0jsi/ABI50_0_0JSIDynamic.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0hermes {
namespace inspector_modern {
namespace chrome {
namespace message {

std::string stripCachePrevention(const std::string &url);

template <typename T>
void setHermesLocation(
    ABI50_0_0facebook::ABI50_0_0hermes::debugger::SourceLocation &hermesLoc,
    const T &chromeLoc,
    const std::vector<std::string> &parsedScripts) {
  hermesLoc.line = chromeLoc.lineNumber + 1;

  if (chromeLoc.columnNumber.has_value()) {
    if (chromeLoc.columnNumber.value() == 0) {
      // TODO: When CDTP sends a column number of 0, we send Hermes a column
      // number of 1. For some reason, this causes Hermes to not be
      // able to resolve breakpoints.
      hermesLoc.column = ::ABI50_0_0facebook::ABI50_0_0hermes::debugger::kInvalidLocation;
    } else {
      hermesLoc.column = chromeLoc.columnNumber.value() + 1;
    }
  }

  if (chromeLoc.url.has_value()) {
    hermesLoc.fileName = stripCachePrevention(chromeLoc.url.value());
  } else if (chromeLoc.urlRegex.has_value()) {
    const std::regex regex(stripCachePrevention(chromeLoc.urlRegex.value()));
    auto it = parsedScripts.rbegin();

    // We currently only support one physical breakpoint per location, so
    // search backwards so that we find the latest matching file.
    while (it != parsedScripts.rend()) {
      if (std::regex_match(*it, regex)) {
        hermesLoc.fileName = *it;
        break;
      }
      it++;
    }
  }
}

template <typename T>
void setChromeLocation(
    T &chromeLoc,
    const ABI50_0_0facebook::ABI50_0_0hermes::debugger::SourceLocation &hermesLoc) {
  if (hermesLoc.line != ABI50_0_0facebook::ABI50_0_0hermes::debugger::kInvalidLocation) {
    chromeLoc.lineNumber = hermesLoc.line - 1;
  }

  if (hermesLoc.column != ABI50_0_0facebook::ABI50_0_0hermes::debugger::kInvalidLocation) {
    chromeLoc.columnNumber = hermesLoc.column - 1;
  }
}

/// ErrorCode magic numbers match JSC's (see InspectorBackendDispatcher.cpp)
enum class ErrorCode {
  ParseError = -32700,
  InvalidRequest = -32600,
  MethodNotFound = -32601,
  InvalidParams = -32602,
  InternalError = -32603,
  ServerError = -32000
};

ErrorResponse
makeErrorResponse(int id, ErrorCode code, const std::string &message);

OkResponse makeOkResponse(int id);

namespace debugger {

Location makeLocation(const ABI50_0_0facebook::ABI50_0_0hermes::debugger::SourceLocation &loc);

CallFrame makeCallFrame(
    uint32_t callFrameIndex,
    const ABI50_0_0facebook::ABI50_0_0hermes::debugger::CallFrameInfo &callFrameInfo,
    const ABI50_0_0facebook::ABI50_0_0hermes::debugger::LexicalInfo &lexicalInfo,
    ABI50_0_0facebook::ABI50_0_0hermes::inspector_modern::chrome::RemoteObjectsTable &objTable,
    jsi::Runtime &runtime,
    const ABI50_0_0facebook::ABI50_0_0hermes::debugger::ProgramState &state);

std::vector<CallFrame> makeCallFrames(
    const ABI50_0_0facebook::ABI50_0_0hermes::debugger::ProgramState &state,
    ABI50_0_0facebook::ABI50_0_0hermes::inspector_modern::chrome::RemoteObjectsTable &objTable,
    jsi::Runtime &runtime);

} // namespace debugger

namespace runtime {

CallFrame makeCallFrame(const ABI50_0_0facebook::ABI50_0_0hermes::debugger::CallFrameInfo &info);

std::vector<CallFrame> makeCallFrames(
    const ABI50_0_0facebook::ABI50_0_0hermes::debugger::StackTrace &stackTrace);

ExceptionDetails makeExceptionDetails(
    const ABI50_0_0facebook::ABI50_0_0hermes::debugger::ExceptionDetails &details);

RemoteObject makeRemoteObject(
    ABI50_0_0facebook::jsi::Runtime &runtime,
    const ABI50_0_0facebook::jsi::Value &value,
    ABI50_0_0facebook::ABI50_0_0hermes::inspector_modern::chrome::RemoteObjectsTable &objTable,
    const std::string &objectGroup,
    bool byValue = false,
    bool generatePreview = false);

} // namespace runtime

} // namespace message
} // namespace chrome
} // namespace inspector_modern
} // namespace ABI50_0_0hermes
} // namespace ABI50_0_0facebook
