#pragma once

#include "JSScheduler.h"

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <memory>
#include <string>

using namespace ABI50_0_0facebook;

namespace ABI50_0_0reanimated {

class WorkletRuntimeDecorator {
 public:
  static void decorate(
      jsi::Runtime &rt,
      const std::string &name,
      const std::shared_ptr<JSScheduler> &jsScheduler);
};

} // namespace reanimated
