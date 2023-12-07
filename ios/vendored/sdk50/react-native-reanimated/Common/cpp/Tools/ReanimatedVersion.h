#pragma once

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <memory>
#include <string>
#include "JSLogger.h"

using namespace ABI50_0_0facebook;

namespace ABI50_0_0reanimated {

std::string getReanimatedCppVersion();

bool matchVersion(const std::string &, const std::string &);
void checkJSVersion(jsi::Runtime &, const std::shared_ptr<JSLogger> &);

}; // namespace reanimated
