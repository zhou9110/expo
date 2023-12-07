#if defined(ABI50_0_0RCT_NEW_ARCH_ENABLED) && ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 73

#include "ReanimatedMountHook.h"
#include "ReanimatedCommitMarker.h"

namespace ABI50_0_0reanimated {

ReanimatedMountHook::ReanimatedMountHook(
    const std::shared_ptr<PropsRegistry> &propsRegistry,
    const std::shared_ptr<UIManager> &uiManager)
    : propsRegistry_(propsRegistry), uiManager_(uiManager) {
  uiManager_->registerMountHook(*this);
}

ReanimatedMountHook::~ReanimatedMountHook() noexcept {
  uiManager_->unregisterMountHook(*this);
}

void ReanimatedMountHook::shadowTreeDidMount(
    RootShadowNode::Shared const &,
    double) noexcept {
  // When commit from ABI50_0_0React Native has finished, we reset the skip commit flag
  // in order to allow Reanimated to commit its tree
  if (!ReanimatedCommitMarker::isReanimatedCommit()) {
    propsRegistry_->resetReanimatedSkipCommitFlag();
  }
}

} // namespace reanimated

#endif // defined(ABI50_0_0RCT_NEW_ARCH_ENABLED) && ABI50_0_0REACT_NATIVE_MINOR_VERSION >= 73
