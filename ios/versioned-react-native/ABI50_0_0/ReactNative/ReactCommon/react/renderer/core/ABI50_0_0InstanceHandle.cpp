/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0InstanceHandle.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

InstanceHandle::InstanceHandle(
    jsi::Runtime& runtime,
    const jsi::Value& instanceHandle,
    Tag tag)
    : weakInstanceHandle_(
          jsi::WeakObject(runtime, instanceHandle.asObject(runtime))),
      tag_(tag) {}

jsi::Value InstanceHandle::getInstanceHandle(jsi::Runtime& runtime) const {
  return weakInstanceHandle_.lock(runtime);
}

Tag InstanceHandle::getTag() const {
  return tag_;
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
