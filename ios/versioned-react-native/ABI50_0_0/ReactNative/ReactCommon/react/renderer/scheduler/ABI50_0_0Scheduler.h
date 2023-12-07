/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>
#include <mutex>

#include <ABI50_0_0ReactCommon/ABI50_0_0RuntimeExecutor.h>
#include "ABI50_0_0ReactNativeConfig.h"
#include <ABI50_0_0React/renderer/componentregistry/ABI50_0_0ComponentDescriptorFactory.h>
#include <ABI50_0_0React/renderer/components/root/ABI50_0_0RootComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ComponentDescriptor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventEmitter.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventListener.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0LayoutConstraints.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0MountingOverrideDelegate.h>
#include <ABI50_0_0React/renderer/scheduler/ABI50_0_0InspectorData.h>
#include <ABI50_0_0React/renderer/scheduler/ABI50_0_0SchedulerDelegate.h>
#include <ABI50_0_0React/renderer/scheduler/ABI50_0_0SchedulerToolbox.h>
#include <ABI50_0_0React/renderer/scheduler/ABI50_0_0SurfaceHandler.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManagerAnimationDelegate.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManagerBinding.h>
#include <ABI50_0_0React/renderer/uimanager/ABI50_0_0UIManagerDelegate.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

/*
 * Scheduler coordinates Shadow Tree updates and event flows.
 */
class Scheduler final : public UIManagerDelegate {
 public:
  Scheduler(
      const SchedulerToolbox& schedulerToolbox,
      UIManagerAnimationDelegate* animationDelegate,
      SchedulerDelegate* delegate);
  ~Scheduler() override;

#pragma mark - Surface Management

  /*
   * Registers and unregisters a `SurfaceHandler` object in the `Scheduler`.
   * All registered `SurfaceHandler` objects must be unregistered
   * (with the same `Scheduler`) before their deallocation.
   */
  void registerSurface(const SurfaceHandler& surfaceHandler) const noexcept;
  void unregisterSurface(const SurfaceHandler& surfaceHandler) const noexcept;

  InspectorData getInspectorDataForInstance(
      const EventEmitter& eventEmitter) const noexcept;

  void renderTemplateToSurface(
      SurfaceId surfaceId,
      const std::string& uiTemplate);

  /*
   * This is broken. Please do not use.
   * `ComponentDescriptor`s are not designed to be used outside of `UIManager`,
   * there is no any guarantees about their lifetime.
   */
  const ComponentDescriptor*
  findComponentDescriptorByHandle_DO_NOT_USE_THIS_IS_BROKEN(
      ComponentHandle handle) const;

#pragma mark - Delegate

  /*
   * Sets and gets the Scheduler's delegate.
   * If you requesting a ComponentDescriptor and unsure that it's there, you are
   * doing something wrong.
   */
  void setDelegate(SchedulerDelegate* delegate);
  SchedulerDelegate* getDelegate() const;

#pragma mark - UIManagerAnimationDelegate
  // This is not needed on iOS or any platform that has a "pull" instead of
  // "push" MountingCoordinator model. This just tells the delegate an update
  // is available and that it should `pullTransaction`; we may want to rename
  // this to be more generic and not animation-specific.
  void animationTick() const;

#pragma mark - UIManagerDelegate

  void uiManagerDidFinishTransaction(
      MountingCoordinator::Shared mountingCoordinator,
      bool mountSynchronously) override;
  void uiManagerDidCreateShadowNode(const ShadowNode& shadowNode) override;
  void uiManagerDidDispatchCommand(
      const ShadowNode::Shared& shadowNode,
      const std::string& commandName,
      const folly::dynamic& args) override;
  void uiManagerDidSendAccessibilityEvent(
      const ShadowNode::Shared& shadowNode,
      const std::string& eventType) override;
  void uiManagerDidSetIsJSResponder(
      const ShadowNode::Shared& shadowNode,
      bool isJSResponder,
      bool blockNativeResponder) override;

#pragma mark - ContextContainer
  ContextContainer::Shared getContextContainer() const;

#pragma mark - UIManager
  std::shared_ptr<UIManager> getUIManager() const;

  void reportMount(SurfaceId surfaceId) const;

#pragma mark - Event listeners
  void addEventListener(const std::shared_ptr<const EventListener>& listener);
  void removeEventListener(
      const std::shared_ptr<const EventListener>& listener);

 private:
  friend class SurfaceHandler;

  SchedulerDelegate* delegate_;
  SharedComponentDescriptorRegistry componentDescriptorRegistry_;
  RuntimeExecutor runtimeExecutor_;
  std::shared_ptr<UIManager> uiManager_;
  std::shared_ptr<const ABI50_0_0ReactNativeConfig> ABI50_0_0ReactNativeConfig_;

  std::vector<std::shared_ptr<UIManagerCommitHook>> commitHooks_;

  /*
   * At some point, we have to have an owning shared pointer to something that
   * will become an `EventDispatcher` a moment later. That's why we have it as a
   * pointer to an optional: we construct the pointer first, share that with
   * parts that need to have ownership (and only ownership) of that, and then
   * fill the optional.
   */
  std::shared_ptr<std::optional<const EventDispatcher>> eventDispatcher_;

  /**
   * Hold onto ContextContainer. See SchedulerToolbox.
   * Must not be nullptr.
   */
  ContextContainer::Shared contextContainer_;

  /*
   * Temporary flags.
   */
  bool removeOutstandingSurfacesOnDestruction_{false};
  bool reduceDeleteCreateMutationLayoutAnimation_{false};
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
