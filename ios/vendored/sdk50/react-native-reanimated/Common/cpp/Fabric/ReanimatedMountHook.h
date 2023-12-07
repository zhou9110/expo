#pragma once

#if defined(ABI50_0_0RCT_NEW_ARCH_ENABLED) && ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 73

#include "PropsRegistry.h"

#include <react/renderer/uimanager/UIManagerMountHook.h>

#include <memory>

namespace ABI50_0_0reanimated {

using namespace ABI50_0_0facebook::ABI50_0_0React;

class ReanimatedMountHook : public UIManagerMountHook {
 public:
  ReanimatedMountHook(
      const std::shared_ptr<PropsRegistry> &propsRegistry,
      const std::shared_ptr<UIManager> &uiManager);
  ~ReanimatedMountHook() noexcept override;

  void shadowTreeDidMount(
      RootShadowNode::Shared const &rootShadowNode,
      double mountTime) noexcept override;

 private:
  const std::shared_ptr<PropsRegistry> propsRegistry_;
  const std::shared_ptr<UIManager> uiManager_;
};

} // namespace reanimated

#endif // defined(ABI50_0_0RCT_NEW_ARCH_ENABLED) && ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 73
