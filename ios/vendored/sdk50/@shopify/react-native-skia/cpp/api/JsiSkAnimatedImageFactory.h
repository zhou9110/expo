#pragma once

#include <memory>
#include <utility>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include "JsiPromises.h"
#include "JsiSkAnimatedImage.h"
#include "JsiSkData.h"
#include "JsiSkHostObjects.h"

namespace ABI50_0_0RNSkia {

namespace jsi = ABI50_0_0facebook::jsi;

class JsiSkAnimatedImageFactory : public JsiSkHostObject {
public:
  JSI_HOST_FUNCTION(MakeAnimatedImageFromEncoded) {
    auto data = JsiSkData::fromValue(runtime, arguments[0]);
    auto codec = SkAndroidCodec::MakeFromData(data);
    auto image = SkAnimatedImage::Make(std::move(codec));
    if (image == nullptr) {
      return jsi::Value::null();
    }
    return jsi::Object::createFromHostObject(
        runtime,
        std::make_shared<JsiSkAnimatedImage>(getContext(), std::move(image)));
  }

  JSI_EXPORT_FUNCTIONS(JSI_EXPORT_FUNC(JsiSkAnimatedImageFactory,
                                       MakeAnimatedImageFromEncoded))

  explicit JsiSkAnimatedImageFactory(
      std::shared_ptr<ABI50_0_0RNSkPlatformContext> context)
      : JsiSkHostObject(std::move(context)) {}
};

} // namespace ABI50_0_0RNSkia
