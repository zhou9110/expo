/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewEventEmitter.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

// This emitter exists only as a placeholder and is not used for communication
// with JS.
//
// See:
// - EventEmitterWrapper::invokeEvent for the Android event emitter dispatch
// - ABI50_0_0ReactTextInputManager.java for the text input events used on Android
class AndroidTextInputEventEmitter : public ViewEventEmitter {
 public:
  using ViewEventEmitter::ViewEventEmitter;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
