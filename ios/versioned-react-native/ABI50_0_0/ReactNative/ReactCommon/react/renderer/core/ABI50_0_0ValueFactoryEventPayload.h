/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0React/renderer/core/ABI50_0_0EventPayload.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ValueFactory.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class ValueFactoryEventPayload : public EventPayload {
 public:
  explicit ValueFactoryEventPayload(ValueFactory factory);
  jsi::Value asJSIValue(jsi::Runtime& runtime) const override;
  EventPayloadType getType() const override;

 private:
  ValueFactory valueFactory_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
