#pragma once
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED

#include <react/renderer/core/PropsParserContext.h>
#include <react/renderer/uimanager/UIManager.h>

#include <memory>
#include <set>

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0React;

namespace ABI50_0_0reanimated {

ShadowNode::Unshared cloneShadowTreeWithNewProps(
    const ShadowNode::Shared &oldRootNode,
    const ShadowNodeFamily &family,
    RawProps &&rawProps);

} // namespace reanimated

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
