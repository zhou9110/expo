/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <exception>

#include <glog/logging.h>
#include <gtest/gtest.h>
#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#include <ABI50_0_0React/renderer/templateprocessor/ABI50_0_0UITemplateProcessor.h>

using namespace ABI50_0_0facebook::ABI50_0_0React;

#include <ABI50_0_0React/config/ABI50_0_0ReactNativeConfig.h>
#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorProviderRegistry.h>
#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorRegistry.h>
#include <ABI50_0_0React/renderer/components/rncore/ABI50_0_0ComponentDescriptors.h>
#include <ABI50_0_0React/renderer/components/scrollview/ABI50_0_0ScrollViewComponentDescriptor.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewComponentDescriptor.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

static ComponentRegistryFactory getComponentRegistryFactory() {
  return [](const EventDispatcher::Weak& eventDispatcher,
            const ContextContainer::Shared& contextContainer) {
    ComponentDescriptorProviderRegistry providerRegistry{};
    providerRegistry.add(
        concreteComponentDescriptorProvider<ViewComponentDescriptor>());
    providerRegistry.add(
        concreteComponentDescriptorProvider<ScrollViewComponentDescriptor>());
    providerRegistry.add(concreteComponentDescriptorProvider<
                         ActivityIndicatorViewComponentDescriptor>());
    return providerRegistry.createComponentDescriptorRegistry(
        {eventDispatcher, contextContainer});
  };
}

bool mockSimpleTestValue_;

NativeModuleRegistry buildNativeModuleRegistry();

NativeModuleRegistry buildNativeModuleRegistry() {
  NativeModuleRegistry nMR;
  nMR.registerModule(
      "MobileConfig",
      [&](const std::string& /*unused*/, const folly::dynamic& /*unused*/) {
        return mockSimpleTestValue_;
      });
  return nMR;
}

class MockABI50_0_0ReactNativeConfig : public ABI50_0_0ReactNativeConfig {
 public:
  MockABI50_0_0ReactNativeConfig() = default;
  bool getBool(const std::string& /*param*/) const override {
    return mockSimpleTestValue_;
  }

  std::string getString(const std::string& /*param*/) const override {
    return "";
  }

  int64_t getInt64(const std::string& /*param*/) const override {
    return 0;
  }

  double getDouble(const std::string& /*param*/) const override {
    return 0.0;
  }
};

std::shared_ptr<const ABI50_0_0ReactNativeConfig> mockABI50_0_0ReactNativeConfig_ =
    std::make_shared<const MockABI50_0_0ReactNativeConfig>();

} // namespace ABI50_0_0facebook::ABI50_0_0React

TEST(UITemplateProcessorTest, testSimpleBytecode) {
  auto surfaceId = 11;
  auto eventDispatcher = std::shared_ptr<const EventDispatcher>();
  auto componentDescriptorRegistry =
      getComponentRegistryFactory()(eventDispatcher, nullptr);
  auto nativeModuleRegistry = buildNativeModuleRegistry();

  auto bytecode = R"delim({"version":0.1,"commands":[
    ["createNode",2,"ABI50_0_0RCTView",-1,{"opacity": 0.5, "testID": "root"}],
    ["createNode",4,"ABI50_0_0RCTView",2,{"testID": "child"}],
    ["returnRoot",2]
  ]})delim";

  mockSimpleTestValue_ = true;

  auto root1 = UITemplateProcessor::buildShadowTree(
      bytecode,
      surfaceId,
      folly::dynamic::object(),
      *componentDescriptorRegistry,
      nativeModuleRegistry,
      mockABI50_0_0ReactNativeConfig_);
#ifndef NDEBUG
  LOG(INFO) << std::endl << root1->getDebugDescription();
#endif
  auto props1 = std::static_pointer_cast<const ViewProps>(root1->getProps());
  ABI50_0_0EXPECT_NEAR(props1->opacity, 0.5, 0.001);
  ASSERT_STREQ(props1->testId.c_str(), "root");
  auto children1 = root1->getChildren();
  ABI50_0_0EXPECT_EQ(children1.size(), 1);
  auto child_props1 =
      std::static_pointer_cast<const ViewProps>(children1.at(0)->getProps());
  ASSERT_STREQ(child_props1->testId.c_str(), "child");
}

TEST(UITemplateProcessorTest, testConditionalBytecode) {
  auto surfaceId = 11;
  auto eventDispatcher = std::shared_ptr<const EventDispatcher>();
  auto componentDescriptorRegistry =
      getComponentRegistryFactory()(eventDispatcher, nullptr);
  auto nativeModuleRegistry = buildNativeModuleRegistry();

  auto bytecode = R"delim({"version":0.1,"commands":[
    ["createNode",2,"ABI50_0_0RCTView",-1,{"testID": "root"}],
    ["loadNativeBool",1,"MobileConfig","getBool",["qe:simple_test"]],
    ["conditional",1,
      [["createNode",4,"ABI50_0_0RCTView",2,{"testID": "cond_true"}]],
      [["createNode",4,"ABI50_0_0RCTView",2,{"testID": "cond_false"}]]
    ],
    ["returnRoot",2]
  ]})delim";

  mockSimpleTestValue_ = true;

  auto root1 = UITemplateProcessor::buildShadowTree(
      bytecode,
      surfaceId,
      folly::dynamic::object(),
      *componentDescriptorRegistry,
      nativeModuleRegistry,
      mockABI50_0_0ReactNativeConfig_);
#ifndef NDEBUG
  LOG(INFO) << std::endl << root1->getDebugDescription();
#endif
  auto props1 = std::static_pointer_cast<const ViewProps>(root1->getProps());
  ASSERT_STREQ(props1->testId.c_str(), "root");
  auto children1 = root1->getChildren();
  ABI50_0_0EXPECT_EQ(children1.size(), 1);
  auto child_props1 =
      std::static_pointer_cast<const ViewProps>(children1.at(0)->getProps());
  ASSERT_STREQ(child_props1->testId.c_str(), "cond_true");

  mockSimpleTestValue_ = false;

  auto root2 = UITemplateProcessor::buildShadowTree(
      bytecode,
      surfaceId,
      folly::dynamic::object(),
      *componentDescriptorRegistry,
      nativeModuleRegistry,
      mockABI50_0_0ReactNativeConfig_);
  auto child_props2 = std::static_pointer_cast<const ViewProps>(
      root2->getChildren().at(0)->getProps());
  ASSERT_STREQ(child_props2->testId.c_str(), "cond_false");
}
