/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <folly/dynamic.h>

#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsMacros.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0RawProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ReactPrimitives.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0Sealable.h>
#include <ABI50_0_0React/renderer/debug/ABI50_0_0DebugStringConvertible.h>

#ifdef ANDROID
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBufferBuilder.h>
#endif

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Represents the most generic props object.
 */
class Props : public virtual Sealable, public virtual DebugStringConvertible {
 public:
  using Shared = std::shared_ptr<const Props>;

  Props() = default;
  Props(
      const PropsParserContext& context,
      const Props& sourceProps,
      const RawProps& rawProps);
  virtual ~Props() = default;

  /**
   * Set a prop value via iteration (see enableIterator above).
   * If setProp is defined for a particular props struct, it /must/
   * be called every time setProp is called on the hierarchy.
   * For example, ViewProps overrides setProp and so ViewProps must
   * explicitly call Props::setProp every time ViewProps::setProp is
   * called. This is because a single prop from JS can be reused
   * multiple times for different values in the hierarchy. For example, if
   * ViewProps uses "propX", Props may also use "propX".
   */
  void setProp(
      const PropsParserContext& context,
      RawPropsPropNameHash hash,
      const char* propName,
      const RawValue& value);

  std::string nativeId;

#ifdef ANDROID
  folly::dynamic rawProps = folly::dynamic::object();

  virtual void propsDiffMapBuffer(
      const Props* oldProps,
      MapBufferBuilder& builder) const;
#endif

 protected:
  /** Initialize member variables of Props instance */
  void initialize(
      const PropsParserContext& context,
      const Props& sourceProps,
      const RawProps& rawProps);
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
