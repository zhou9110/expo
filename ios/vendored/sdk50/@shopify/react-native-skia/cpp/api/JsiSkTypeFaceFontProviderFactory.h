#pragma once

#include <memory>
#include <utility>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include "JsiSkData.h"
#include "JsiSkHostObjects.h"
#include "JsiSkTypeFaceFontProvider.h"

namespace ABI50_0_0RNSkia {

namespace jsi = ABI50_0_0facebook::jsi;
namespace para = skia::textlayout;

class JsiSkTypefaceFontProviderFactory : public JsiSkHostObject {
public:
  JSI_HOST_FUNCTION(Make) {
    return jsi::Object::createFromHostObject(
        runtime, std::make_shared<JsiSkTypefaceFontProvider>(
                     getContext(), sk_make_sp<para::TypefaceFontProvider>()));
  }

  JSI_EXPORT_FUNCTIONS(JSI_EXPORT_FUNC(JsiSkTypefaceFontProviderFactory, Make))

  explicit JsiSkTypefaceFontProviderFactory(
      std::shared_ptr<ABI50_0_0RNSkPlatformContext> context)
      : JsiSkHostObject(std::move(context)) {}
};

} // namespace ABI50_0_0RNSkia
