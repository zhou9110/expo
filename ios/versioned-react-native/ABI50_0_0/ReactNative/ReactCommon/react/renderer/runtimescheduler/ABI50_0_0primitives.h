/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0Task.h>
#include <ABI50_0_0React/utils/ABI50_0_0CoreFeatures.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

struct TaskWrapper : public jsi::HostObject {
  TaskWrapper(const std::shared_ptr<Task>& task) : task(task) {}

  std::shared_ptr<Task> task;
};

inline static jsi::Value valueFromTask(
    jsi::Runtime& runtime,
    std::shared_ptr<Task> task) {
  if (CoreFeatures::useNativeState) {
    jsi::Object obj(runtime);
    obj.setNativeState(runtime, std::move(task));
    return obj;
  } else {
    return jsi::Object::createFromHostObject(
        runtime, std::make_shared<TaskWrapper>(task));
  }
}

inline static std::shared_ptr<Task> taskFromValue(
    jsi::Runtime& runtime,
    const jsi::Value& value) {
  if (value.isNull()) {
    return nullptr;
  }

  if (CoreFeatures::useNativeState) {
    return value.getObject(runtime).getNativeState<Task>(runtime);
  } else {
    return value.getObject(runtime).getHostObject<TaskWrapper>(runtime)->task;
  }
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
