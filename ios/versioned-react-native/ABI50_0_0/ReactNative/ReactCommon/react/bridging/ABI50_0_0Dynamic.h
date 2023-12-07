/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <folly/dynamic.h>
#include <ABI50_0_0jsi/ABI50_0_0JSIDynamic.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

template <>
struct Bridging<folly::dynamic> {
  static folly::dynamic fromJs(jsi::Runtime& rt, const jsi::Value& value) {
    return jsi::dynamicFromValue(rt, value);
  }

  static jsi::Value toJs(jsi::Runtime& rt, const folly::dynamic& value) {
    return jsi::valueFromDynamic(rt, value);
  }
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
