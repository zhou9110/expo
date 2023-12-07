/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0NativeIntersectionObserver.h"
#include <ABI50_0_0React/ABI50_0_0renderer/core/ShadowNode.h>
#include <ABI50_0_0React/ABI50_0_0renderer/uimanager/UIManagerBinding.h>
#include <ABI50_0_0React/ABI50_0_0renderer/uimanager/primitives.h>

#include "ABI50_0_0Plugins.h"

std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>
NativeIntersectionObserverModuleProvider(
    std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker> jsInvoker) {
  return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::NativeIntersectionObserver>(
      std::move(jsInvoker));
}

namespace ABI50_0_0facebook::ABI50_0_0React {

NativeIntersectionObserver::NativeIntersectionObserver(
    std::shared_ptr<CallInvoker> jsInvoker)
    : ABI50_0_0NativeIntersectionObserverCxxSpec(std::move(jsInvoker)) {}

void NativeIntersectionObserver::observe(
    jsi::Runtime& runtime,
    NativeIntersectionObserverObserveOptions options) {
  auto intersectionObserverId = options.intersectionObserverId;
  auto shadowNode =
      shadowNodeFromValue(runtime, std::move(options.targetShadowNode));
  auto thresholds = options.thresholds;
  auto& uiManager = getUIManagerFromRuntime(runtime);

  intersectionObserverManager_.observe(
      intersectionObserverId, shadowNode, thresholds, uiManager);
}

void NativeIntersectionObserver::unobserve(
    jsi::Runtime& runtime,
    IntersectionObserverObserverId intersectionObserverId,
    jsi::Object targetShadowNode) {
  auto shadowNode = shadowNodeFromValue(runtime, std::move(targetShadowNode));
  intersectionObserverManager_.unobserve(intersectionObserverId, *shadowNode);
}

void NativeIntersectionObserver::connect(
    jsi::Runtime& runtime,
    AsyncCallback<> notifyIntersectionObserversCallback) {
  auto& uiManager = getUIManagerFromRuntime(runtime);
  intersectionObserverManager_.connect(
      uiManager, notifyIntersectionObserversCallback);
}

void NativeIntersectionObserver::disconnect(jsi::Runtime& runtime) {
  auto& uiManager = getUIManagerFromRuntime(runtime);
  intersectionObserverManager_.disconnect(uiManager);
}

std::vector<NativeIntersectionObserverEntry>
NativeIntersectionObserver::takeRecords(jsi::Runtime& runtime) {
  auto entries = intersectionObserverManager_.takeRecords();

  std::vector<NativeIntersectionObserverEntry> nativeModuleEntries;
  nativeModuleEntries.reserve(entries.size());

  for (const auto& entry : entries) {
    nativeModuleEntries.emplace_back(
        convertToNativeModuleEntry(entry, runtime));
  }

  return nativeModuleEntries;
}

NativeIntersectionObserverEntry
NativeIntersectionObserver::convertToNativeModuleEntry(
    IntersectionObserverEntry entry,
    jsi::Runtime& runtime) {
  RectAsTuple targetRect = {
      entry.targetRect.origin.x,
      entry.targetRect.origin.y,
      entry.targetRect.size.width,
      entry.targetRect.size.height};
  RectAsTuple rootRect = {
      entry.rootRect.origin.x,
      entry.rootRect.origin.y,
      entry.rootRect.size.width,
      entry.rootRect.size.height};
  std::optional<RectAsTuple> intersectionRect;
  if (entry.intersectionRect) {
    intersectionRect = {
        entry.intersectionRect.value().origin.x,
        entry.intersectionRect.value().origin.y,
        entry.intersectionRect.value().size.width,
        entry.intersectionRect.value().size.height};
  }

  NativeIntersectionObserverEntry nativeModuleEntry = {
      entry.intersectionObserverId,
      (*entry.shadowNode).getInstanceHandle(runtime),
      targetRect,
      rootRect,
      intersectionRect,
      entry.isIntersectingAboveThresholds,
      entry.time,
  };

  return nativeModuleEntry;
}

UIManager& NativeIntersectionObserver::getUIManagerFromRuntime(
    jsi::Runtime& runtime) {
  return UIManagerBinding::getBinding(runtime)->getUIManager();
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
