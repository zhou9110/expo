/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include "ABI50_0_0LegacyViewManagerInteropComponentDescriptor.h"
#include <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#include <ABI50_0_0React/ABI50_0_0RCTBridgeModuleDecorator.h>
#include <ABI50_0_0React/ABI50_0_0RCTBridgeProxy.h>
#include <ABI50_0_0React/ABI50_0_0RCTComponentData.h>
#include <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#include <ABI50_0_0React/ABI50_0_0RCTModuleData.h>
#include <ABI50_0_0React/utils/ABI50_0_0ContextContainer.h>
#include <ABI50_0_0React/utils/ABI50_0_0ManagedObjectWrapper.h>
#include "ABI50_0_0LegacyViewManagerInteropState.h"
#include "ABI50_0_0RCTLegacyViewManagerInteropCoordinator.h"

namespace ABI50_0_0facebook::ABI50_0_0React {

static std::string moduleNameFromComponentNameNoABI50_0_0RCTPrefix(const std::string &componentName)
{
  // TODO: remove FB specific code (T56174424)
  if (componentName == "StickerInputView") {
    return "FBStickerInputViewManager";
  }

  if (componentName == "FDSTooltipView") {
    return "FBABI50_0_0ReactFDSTooltipViewManager";
  }

  std::string fbPrefix("FB");
  if (std::mismatch(fbPrefix.begin(), fbPrefix.end(), componentName.begin()).first == fbPrefix.end()) {
    // If `moduleName` has "FB" prefix.
    return componentName + "Manager";
  }

  std::string artPrefix("ABI50_0_0ART");
  if (std::mismatch(artPrefix.begin(), artPrefix.end(), componentName.begin()).first == artPrefix.end()) {
    return componentName + "Manager";
  }

  std::string rnPrefix("ABI50_0_0RN");
  if (std::mismatch(rnPrefix.begin(), rnPrefix.end(), componentName.begin()).first == rnPrefix.end()) {
    return componentName + "Manager";
  }

  return componentName + "Manager";
}

inline NSString *ABI50_0_0RCTNSStringFromString(const std::string &string)
{
  return [NSString stringWithUTF8String:string.c_str()];
}

static Class getViewManagerFromComponentName(const std::string &componentName)
{
  auto viewManagerName = moduleNameFromComponentNameNoABI50_0_0RCTPrefix(componentName);

  // 1. Try to get the manager with the ABI50_0_0RCT prefix.
  auto rctViewManagerName = "ABI50_0_0RCT" + viewManagerName;
  Class viewManagerClass = NSClassFromString(ABI50_0_0RCTNSStringFromString(rctViewManagerName));
  if (viewManagerClass) {
    return viewManagerClass;
  }

  // 2. Try to get the manager without the prefix.
  viewManagerClass = NSClassFromString(ABI50_0_0RCTNSStringFromString(viewManagerName));
  if (viewManagerClass) {
    return viewManagerClass;
  }

  return nil;
}

static Class getViewManagerClass(const std::string &componentName, ABI50_0_0RCTBridge *bridge, ABI50_0_0RCTBridgeProxy *bridgeProxy)
{
  Class viewManager = getViewManagerFromComponentName(componentName);
  if (viewManager != nil) {
    return viewManager;
  }

  // If all the heuristics fail, let's try to retrieve the view manager from the bridge/bridgeProxy
  if (bridge != nil) {
    return [[bridge moduleForName:ABI50_0_0RCTNSStringFromString(componentName)] class];
  }

  if (bridgeProxy != nil) {
    return [[bridgeProxy moduleForName:ABI50_0_0RCTNSStringFromString(componentName) lazilyLoadIfNecessary:YES] class];
  }

  return nil;
}

static const std::shared_ptr<void> constructCoordinator(
    const ContextContainer::Shared &contextContainer,
    const ComponentDescriptor::Flavor &flavor)
{
  auto optionalBridge = contextContainer->find<std::shared_ptr<void>>("Bridge");
  ABI50_0_0RCTBridge *bridge;
  if (optionalBridge) {
    bridge = unwrapManagedObjectWeakly(optionalBridge.value());
  }

  ABI50_0_0RCTBridgeProxy *bridgeProxy;
  auto optionalBridgeProxy = contextContainer->find<std::shared_ptr<void>>("ABI50_0_0RCTBridgeProxy");
  if (optionalBridgeProxy) {
    bridgeProxy = unwrapManagedObjectWeakly(optionalBridgeProxy.value());
  }

  auto componentName = *std::static_pointer_cast<std::string const>(flavor);
  Class viewManagerClass = getViewManagerClass(componentName, bridge, bridgeProxy);
  assert(viewManagerClass);

  auto optionalEventDispatcher = contextContainer->find<std::shared_ptr<void>>("ABI50_0_0RCTEventDispatcher");
  ABI50_0_0RCTEventDispatcher *eventDispatcher;
  if (optionalEventDispatcher) {
    eventDispatcher = unwrapManagedObject(optionalEventDispatcher.value());
  }

  auto optionalModuleDecorator = contextContainer->find<std::shared_ptr<void>>("ABI50_0_0RCTBridgeModuleDecorator");
  ABI50_0_0RCTBridgeModuleDecorator *bridgeModuleDecorator;
  if (optionalModuleDecorator) {
    bridgeModuleDecorator = unwrapManagedObject(optionalModuleDecorator.value());
  }

  ABI50_0_0RCTComponentData *componentData = [[ABI50_0_0RCTComponentData alloc] initWithManagerClass:viewManagerClass
                                                                            bridge:bridge
                                                                   eventDispatcher:eventDispatcher];
  return wrapManagedObject([[ABI50_0_0RCTLegacyViewManagerInteropCoordinator alloc]
      initWithComponentData:componentData
                     bridge:bridge
                bridgeProxy:bridgeProxy
      bridgelessInteropData:bridgeModuleDecorator]);
}

LegacyViewManagerInteropComponentDescriptor::LegacyViewManagerInteropComponentDescriptor(
    const ComponentDescriptorParameters &parameters)
    : ConcreteComponentDescriptor(parameters), _coordinator(constructCoordinator(contextContainer_, flavor_))
{
}

ComponentHandle LegacyViewManagerInteropComponentDescriptor::getComponentHandle() const
{
  return reinterpret_cast<ComponentHandle>(getComponentName());
}

ComponentName LegacyViewManagerInteropComponentDescriptor::getComponentName() const
{
  return static_cast<const std::string *>(flavor_.get())->c_str();
}

void LegacyViewManagerInteropComponentDescriptor::adopt(ShadowNode &shadowNode) const
{
  ConcreteComponentDescriptor::adopt(shadowNode);

  auto &legacyViewManagerInteropShadowNode = static_cast<LegacyViewManagerInteropShadowNode &>(shadowNode);

  auto state = LegacyViewManagerInteropState{};
  state.coordinator = _coordinator;

  legacyViewManagerInteropShadowNode.setStateData(std::move(state));
}
} // namespace ABI50_0_0facebook::ABI50_0_0React
