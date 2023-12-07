/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <functional>
#include <string>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventPayload.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventTarget.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactEventPriority.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ValueFactory.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

using EventPipe = std::function<void(
    jsi::Runtime& runtime,
    const EventTarget* eventTarget,
    const std::string& type,
    ABI50_0_0ReactEventPriority priority,
    const EventPayload& payload)>;

using EventPipeConclusion = std::function<void(jsi::Runtime& runtime)>;

} // namespace ABI50_0_0facebook::ABI50_0_0React
