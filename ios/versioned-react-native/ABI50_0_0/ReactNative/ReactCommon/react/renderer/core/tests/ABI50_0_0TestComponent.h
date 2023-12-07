/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ConcreteViewShadowNode.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewEventEmitter.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ConcreteComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0PropsParserContext.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0RawProps.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>

#ifdef ANDROID
#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBuffer.h>
#include <ABI50_0_0React/renderer/mapbuffer/ABI50_0_0MapBufferBuilder.h>
#endif

/**
 * This defines a set of TestComponent classes: Props, ShadowNode,
 * ComponentDescriptor. To be used for testing purpose.
 */

namespace ABI50_0_0facebook::ABI50_0_0React {

struct TestState {
  TestState() = default;

#ifdef ANDROID
  TestState(const TestState& previousState, folly::dynamic&& data){};

  folly::dynamic getDynamic() const {
    return {};
  }

  MapBuffer getMapBuffer() const {
    return MapBufferBuilder::EMPTY();
  }
#endif
};

static const char TestComponentName[] = "Test";

class TestProps : public ViewProps {
 public:
  TestProps() = default;

  TestProps(
      const PropsParserContext& context,
      const TestProps& sourceProps,
      const RawProps& rawProps)
      : ViewProps(context, sourceProps, rawProps) {}
};

using SharedTestProps = std::shared_ptr<const TestProps>;

class TestShadowNode;

using SharedTestShadowNode = std::shared_ptr<const TestShadowNode>;

class TestShadowNode final : public ConcreteViewShadowNode<
                                 TestComponentName,
                                 TestProps,
                                 ViewEventEmitter,
                                 TestState> {
 public:
  using ConcreteViewShadowNode::ConcreteViewShadowNode;

  Transform _transform{Transform::Identity()};

  Transform getTransform() const override {
    return _transform;
  }

  ABI50_0_0facebook::ABI50_0_0React::Point _contentOriginOffset{};

  ABI50_0_0facebook::ABI50_0_0React::Point getContentOriginOffset() const override {
    return _contentOriginOffset;
  }
};

class TestComponentDescriptor
    : public ConcreteComponentDescriptor<TestShadowNode> {
 public:
  using ConcreteComponentDescriptor::ConcreteComponentDescriptor;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
