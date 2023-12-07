#include "WorkletRuntimeRegistry.h"

namespace ABI50_0_0reanimated {

std::set<jsi::Runtime *> WorkletRuntimeRegistry::registry_{};
std::mutex WorkletRuntimeRegistry::mutex_{};

} // namespace reanimated
