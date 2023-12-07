#pragma once

#include "SkImage.h"
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0RNSkia {

namespace jsi = ABI50_0_0facebook::jsi;

class ABI50_0_0RNSkTypedArray {
public:
  static jsi::Value getTypedArray(jsi::Runtime &runtime,
                                  const jsi::Value &value, SkImageInfo &info) {
    auto reqSize = info.computeMinByteSize();
    if (reqSize > 0) {
      if (value.isObject()) {
        auto typedArray = value.asObject(runtime);
        auto size = static_cast<size_t>(
            typedArray.getProperty(runtime, "byteLength").asNumber());
        if (size >= reqSize) {
          return typedArray;
        }
      } else {
        if (info.colorType() == kRGBA_F32_SkColorType) {
          auto arrayCtor =
              runtime.global().getPropertyAsFunction(runtime, "Float32Array");
          return arrayCtor.callAsConstructor(runtime,
                                             static_cast<double>(reqSize / 4));
        } else {
          auto arrayCtor =
              runtime.global().getPropertyAsFunction(runtime, "Uint8Array");
          return arrayCtor.callAsConstructor(runtime,
                                             static_cast<double>(reqSize));
        }
      }
    }
    return jsi::Value::null();
  }
};

} // namespace ABI50_0_0RNSkia
