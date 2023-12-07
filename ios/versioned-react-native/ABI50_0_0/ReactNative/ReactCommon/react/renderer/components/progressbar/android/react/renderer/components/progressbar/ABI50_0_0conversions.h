/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0Props.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0propsConversions.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

#ifdef ANDROID
inline folly::dynamic toDynamic(const AndroidProgressBarProps& props) {
  folly::dynamic serializedProps = folly::dynamic::object();
  serializedProps["styleAttr"] = props.styleAttr;
  serializedProps["typeAttr"] = props.typeAttr;
  serializedProps["indeterminate"] = props.indeterminate;
  serializedProps["progress"] = props.progress;
  serializedProps["animating"] = props.animating;
  serializedProps["color"] = toAndroidRepr(props.color);
  serializedProps["testID"] = props.testID;
  return serializedProps;
}
#endif

} // namespace ABI50_0_0facebook::ABI50_0_0React
