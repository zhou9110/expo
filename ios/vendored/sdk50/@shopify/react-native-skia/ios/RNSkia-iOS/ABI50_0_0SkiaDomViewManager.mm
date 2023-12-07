
#include <ABI50_0_0React/ABI50_0_0RCTBridge+Private.h>
#include <ABI50_0_0SkiaDomViewManager.h>

#include <ABI50_0_0RNSkDomView.h>
#include <ABI50_0_0RNSkIOSView.h>
#include <ABI50_0_0RNSkPlatformContext.h>

#include <ABI50_0_0RNSkiaModule.h>
#include <ABI50_0_0SkiaManager.h>
#include <ABI50_0_0SkiaUIView.h>

@implementation ABI50_0_0SkiaDomViewManager

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0SkiaDomView)

- (ABI50_0_0SkiaManager *)skiaManager {
  auto bridge = [ABI50_0_0RCTBridge currentBridge];
  auto skiaModule = (ABI50_0_0RNSkiaModule *)[bridge moduleForName:@"ABI50_0_0RNSkiaModule"];
  return [skiaModule manager];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(nativeID, NSNumber, ABI50_0_0SkiaUIView) {
  // Get parameter
  int nativeId = [[ABI50_0_0RCTConvert NSString:json] intValue];
  [(ABI50_0_0SkiaUIView *)view setNativeId:nativeId];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(mode, NSString, ABI50_0_0SkiaUIView) {
  std::string mode =
      json != NULL ? [[ABI50_0_0RCTConvert NSString:json] UTF8String] : "default";
  [(ABI50_0_0SkiaUIView *)view setDrawingMode:mode];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(debug, BOOL, ABI50_0_0SkiaUIView) {
  bool debug = json != NULL ? [ABI50_0_0RCTConvert BOOL:json] : false;
  [(ABI50_0_0SkiaUIView *)view setDebugMode:debug];
}

- (UIView *)view {
  auto skManager = [[self skiaManager] skManager];
  // Pass SkManager as a raw pointer to avoid circular dependenciesr
  return [[ABI50_0_0SkiaUIView alloc]
      initWithManager:skManager.get()
              factory:[](std::shared_ptr<ABI50_0_0RNSkia::ABI50_0_0RNSkPlatformContext> context) {
                return std::make_shared<ABI50_0_0RNSkiOSView<ABI50_0_0RNSkia::ABI50_0_0RNSkDomView>>(
                    context);
              }];
}

@end
