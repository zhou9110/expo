#include "ABI50_0_0RNSkManager.h"

#include <memory>
#include <utility>

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

#include <JsiSkApi.h>
#include <ABI50_0_0RNSkJsiViewApi.h>
#include <ABI50_0_0RNSkValueApi.h>
#include <ABI50_0_0RNSkView.h>

#include <JsiDomApi.h>
#include <RuntimeAwareCache.h>

namespace ABI50_0_0RNSkia {
namespace jsi = ABI50_0_0facebook::jsi;

ABI50_0_0RNSkManager::ABI50_0_0RNSkManager(
    jsi::Runtime *jsRuntime,
    std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::CallInvoker> jsCallInvoker,
    std::shared_ptr<ABI50_0_0RNSkPlatformContext> platformContext)
    : _jsRuntime(jsRuntime), _jsCallInvoker(jsCallInvoker),
      _platformContext(platformContext),
      _viewApi(std::make_shared<ABI50_0_0RNSkJsiViewApi>(platformContext)) {

  // Register main runtime
  BaseRuntimeAwareCache::setMainJsRuntime(_jsRuntime);

  // Install bindings
  installBindings();
}

ABI50_0_0RNSkManager::~ABI50_0_0RNSkManager() {
  invalidate();
  // Free up any references
  _viewApi = nullptr;
  _jsRuntime = nullptr;
  _platformContext = nullptr;
  _jsCallInvoker = nullptr;
}

void ABI50_0_0RNSkManager::invalidate() {
  if (_isInvalidated) {
    return;
  }
  _isInvalidated = true;

  // Invalidate members
  _viewApi->invalidate();
  _platformContext->invalidate();
}

void ABI50_0_0RNSkManager::registerSkiaView(size_t nativeId,
                                   std::shared_ptr<ABI50_0_0RNSkView> view) {
  if (!_isInvalidated && _viewApi != nullptr)
    _viewApi->registerSkiaView(nativeId, view);
}

void ABI50_0_0RNSkManager::unregisterSkiaView(size_t nativeId) {
  if (!_isInvalidated && _viewApi != nullptr)
    _viewApi->unregisterSkiaView(nativeId);
}

void ABI50_0_0RNSkManager::setSkiaView(size_t nativeId, std::shared_ptr<ABI50_0_0RNSkView> view) {
  if (!_isInvalidated && _viewApi != nullptr)
    _viewApi->setSkiaView(nativeId, view);
}

void ABI50_0_0RNSkManager::installBindings() {
  // Create the API objects and install it on the global object in the
  // provided runtime.

  auto skiaApi = std::make_shared<JsiSkApi>(*_jsRuntime, _platformContext);
  _jsRuntime->global().setProperty(
      *_jsRuntime, "SkiaApi",
      jsi::Object::createFromHostObject(*_jsRuntime, std::move(skiaApi)));

  _jsRuntime->global().setProperty(
      *_jsRuntime, "SkiaViewApi",
      jsi::Object::createFromHostObject(*_jsRuntime, _viewApi));

  auto skiaValueApi = std::make_shared<ABI50_0_0RNSkValueApi>(_platformContext);
  _jsRuntime->global().setProperty(
      *_jsRuntime, "SkiaValueApi",
      jsi::Object::createFromHostObject(*_jsRuntime, std::move(skiaValueApi)));

  auto skiaDomApi = std::make_shared<JsiDomApi>(_platformContext);
  _jsRuntime->global().setProperty(
      *_jsRuntime, "SkiaDomApi",
      jsi::Object::createFromHostObject(*_jsRuntime, std::move(skiaDomApi)));
}
} // namespace ABI50_0_0RNSkia
