#if __cplusplus

#import <ABI50_0_0RNReanimated/NativeReanimatedModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventDispatcher.h>
#include <memory>

namespace ABI50_0_0reanimated {

std::shared_ptr<ABI50_0_0reanimated::NativeReanimatedModule> createReanimatedModule(
    ABI50_0_0RCTBridge *bridge,
    const std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker> &jsInvoker);

}

#endif
