#pragma once

#import <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0RCTTurboModule.h>

#include <functional>
#include <memory>
#include <string>

#include "ABI50_0_0DisplayLink.h"
#include "ABI50_0_0RNSkPlatformContext.h"
#include "ABI50_0_0ViewScreenshotService.h"

#include <ABI50_0_0jsi/ABI50_0_0jsi.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {
class CallInvoker;
}
} // namespace ABI50_0_0facebook

namespace ABI50_0_0RNSkia {

namespace jsi = ABI50_0_0facebook::jsi;

static void handleNotification(CFNotificationCenterRef center, void *observer,
                               CFStringRef name, const void *object,
                               CFDictionaryRef userInfo);

class ABI50_0_0RNSkiOSPlatformContext : public ABI50_0_0RNSkPlatformContext {
public:
  ABI50_0_0RNSkiOSPlatformContext(jsi::Runtime *runtime, ABI50_0_0RCTBridge *bridge)
      : ABI50_0_0RNSkPlatformContext(runtime, bridge.jsCallInvoker,
                            [[UIScreen mainScreen] scale]) {

    // We need to make sure we invalidate when modules are freed
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetLocalCenter(), this, &handleNotification,
        (__bridge CFStringRef)ABI50_0_0RCTBridgeWillInvalidateModulesNotification, NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately);

    // Create screenshot manager
    _screenshotService =
        [[ABI50_0_0ViewScreenshotService alloc] initWithUiManager:bridge.uiManager];
  }

  ~ABI50_0_0RNSkiOSPlatformContext() {
    CFNotificationCenterRemoveEveryObserver(
        CFNotificationCenterGetLocalCenter(), this);
    stopDrawLoop();
  }

  void startDrawLoop() override;
  void stopDrawLoop() override;

  void runOnMainThread(std::function<void()>) override;

  sk_sp<SkImage> takeScreenshotFromViewTag(size_t tag) override;

  virtual void performStreamOperation(
      const std::string &sourceUri,
      const std::function<void(std::unique_ptr<SkStreamAsset>)> &op) override;

  void raiseError(const std::exception &err) override;
  sk_sp<SkSurface> makeOffscreenSurface(int width, int height) override;
  sk_sp<SkFontMgr> createFontMgr() override;

  void willInvalidateModules() {
    // We need to do some house-cleaning here!
    invalidate();
  }

private:
  ABI50_0_0DisplayLink *_displayLink;
  ABI50_0_0ViewScreenshotService *_screenshotService;
};

static void handleNotification(CFNotificationCenterRef center, void *observer,
                               CFStringRef name, const void *object,
                               CFDictionaryRef userInfo) {
  (static_cast<ABI50_0_0RNSkiOSPlatformContext *>(observer))->willInvalidateModules();
}

} // namespace ABI50_0_0RNSkia
