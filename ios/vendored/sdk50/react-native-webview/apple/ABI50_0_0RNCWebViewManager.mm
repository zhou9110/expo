#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>

#import "ABI50_0_0RNCWebViewManager.h"
#import "ABI50_0_0RNCWebViewImpl.h"
#import "ABI50_0_0RNCWebViewDecisionManager.h"
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
#import "ABI50_0_0RNCWebViewSpec/ABI50_0_0RNCWebViewSpec.h"
#endif

#if TARGET_OS_OSX
#define ABI50_0_0RNCView NSView
@class NSView;
#else
#define ABI50_0_0RNCView UIView
@class UIView;
#endif  // TARGET_OS_OSX

@implementation ABI50_0_0RCTConvert (WKWebView)
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* iOS 13 */
ABI50_0_0RCT_ENUM_CONVERTER(WKContentMode, (@{
  @"recommended": @(WKContentModeRecommended),
  @"mobile": @(WKContentModeMobile),
  @"desktop": @(WKContentModeDesktop),
}), WKContentModeRecommended, integerValue)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 /* iOS 15 */
ABI50_0_0RCT_ENUM_CONVERTER(ABI50_0_0RNCWebViewPermissionGrantType, (@{
  @"grantIfSameHostElsePrompt": @(ABI50_0_0RNCWebViewPermissionGrantType_GrantIfSameHost_ElsePrompt),
  @"grantIfSameHostElseDeny": @(ABI50_0_0RNCWebViewPermissionGrantType_GrantIfSameHost_ElseDeny),
  @"deny": @(ABI50_0_0RNCWebViewPermissionGrantType_Deny),
  @"grant": @(ABI50_0_0RNCWebViewPermissionGrantType_Grant),
  @"prompt": @(ABI50_0_0RNCWebViewPermissionGrantType_Prompt),
}), ABI50_0_0RNCWebViewPermissionGrantType_Prompt, integerValue)
#endif
@end


@implementation ABI50_0_0RNCWebViewManager {
    NSString *_scopeKey;
    NSConditionLock *_shouldStartLoadLock;
    BOOL _shouldStartLoad;
}

ABI50_0_0RCT_EXPORT_MODULE(ABI50_0_0RNCWebView)

- (instancetype)initWithExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                          scopeKey:(NSString *)scopeKey
                      easProjectId:(NSString *)easProjectId
              kernelServiceDelegate:(id)kernelServiceInstance
                            params:(NSDictionary *)params
{
  if (self = [super init]) {
    _scopeKey = scopeKey;
  }
  return self;
}

- (ABI50_0_0RNCView *)view
{
  ABI50_0_0RNCWebViewImpl *webview = [[ABI50_0_0RNCWebViewImpl alloc] init];
  webview.scopeKey = _scopeKey;
  return webview;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(source, NSDictionary)
// New arch only
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(newSource, NSDictionary, ABI50_0_0RNCWebViewImpl) {}
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onFileDownload, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onLoadingStart, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onLoadingFinish, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onLoadingError, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onLoadingProgress, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onHttpError, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onShouldStartLoadWithRequest, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onContentProcessDidTerminate, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onOpenWindow, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(injectedJavaScript, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(injectedJavaScriptBeforeContentLoaded, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(injectedJavaScriptForMainFrameOnly, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(injectedJavaScriptBeforeContentLoadedForMainFrameOnly, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(javaScriptEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(javaScriptCanOpenWindowsAutomatically, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowFileAccessFromFileURLs, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowUniversalAccessFromFileURLs, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowsInlineMediaPlayback, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(webviewDebuggingEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowsAirPlayForMediaPlayback, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(mediaPlaybackRequiresUserAction, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(dataDetectorTypes, WKDataDetectorTypes)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(contentInset, UIEdgeInsets)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustContentInsets, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(autoManageStatusBarEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(hideKeyboardAccessoryView, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowsBackForwardNavigationGestures, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(incognito, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(pagingEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(applicationNameForUserAgent, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(cacheEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowsLinkPreview, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(allowingReadAccessToURL, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(basicAuthCredential, NSDictionary)

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000 /* __IPHONE_11_0 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(contentInsetAdjustmentBehavior, UIScrollViewContentInsetAdjustmentBehavior)
#endif
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* __IPHONE_13_0 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(automaticallyAdjustsScrollIndicatorInsets, BOOL)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* iOS 13 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(contentMode, WKContentMode)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 140000 /* iOS 14 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(limitsNavigationsToAppBoundDomains, BOOL)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 140500 /* iOS 14.5 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(textInteractionEnabled, BOOL)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 150000 /* iOS 15 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(mediaCapturePermissionGrantType, ABI50_0_0RNCWebViewPermissionGrantType)
#endif

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000 /* iOS 13 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(fraudulentWebsiteWarningEnabled, BOOL)
#endif

/**
 * Expose methods to enable messaging the webview.
 */
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(messagingEnabled, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onMessage, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onScroll, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(enableApplePay, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(menuItems, NSArray);
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(suppressMenuItems, NSArray);

// New arch only
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(hasOnFileDownload, BOOL, ABI50_0_0RNCWebViewImpl) {}
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(hasOnOpenWindowEvent, BOOL, ABI50_0_0RNCWebViewImpl) {}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onCustomMenuSelection, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(pullToRefreshEnabled, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.pullToRefreshEnabled = json == nil ? false : [ABI50_0_0RCTConvert BOOL: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(bounces, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.bounces = json == nil ? true : [ABI50_0_0RCTConvert BOOL: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(useSharedProcessPool, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.useSharedProcessPool = json == nil ? true : [ABI50_0_0RCTConvert BOOL: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(userAgent, NSString, ABI50_0_0RNCWebViewImpl) {
  view.userAgent = [ABI50_0_0RCTConvert NSString: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(scrollEnabled, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.scrollEnabled = json == nil ? true : [ABI50_0_0RCTConvert BOOL: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(sharedCookiesEnabled, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.sharedCookiesEnabled = json == nil ? false : [ABI50_0_0RCTConvert BOOL: json];
}

#if !TARGET_OS_OSX
ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(decelerationRate, CGFloat, ABI50_0_0RNCWebViewImpl) {
  view.decelerationRate = json == nil ? UIScrollViewDecelerationRateNormal : [ABI50_0_0RCTConvert CGFloat: json];
}
#endif // !TARGET_OS_OSX

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(directionalLockEnabled, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.directionalLockEnabled = json == nil ? true : [ABI50_0_0RCTConvert BOOL: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(showsHorizontalScrollIndicator, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.showsHorizontalScrollIndicator = json == nil ? true : [ABI50_0_0RCTConvert BOOL: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(showsVerticalScrollIndicator, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.showsVerticalScrollIndicator = json == nil ? true : [ABI50_0_0RCTConvert BOOL: json];
}

ABI50_0_0RCT_CUSTOM_VIEW_PROPERTY(keyboardDisplayRequiresUserAction, BOOL, ABI50_0_0RNCWebViewImpl) {
  view.keyboardDisplayRequiresUserAction = json == nil ? true : [ABI50_0_0RCTConvert BOOL: json];
}

#if !TARGET_OS_OSX
    #define BASE_VIEW_PER_OS() UIView
#else
    #define BASE_VIEW_PER_OS() NSView
#endif

#define QUICK_RCT_EXPORT_COMMAND_METHOD(name)                                                                                           \
ABI50_0_0RCT_EXPORT_METHOD(name:(nonnull NSNumber *)ABI50_0_0ReactTag)                                                                                    \
{                                                                                                                                       \
[self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, BASE_VIEW_PER_OS() *> *viewRegistry) {   \
    ABI50_0_0RNCWebViewImpl *view = (ABI50_0_0RNCWebViewImpl *)viewRegistry[ABI50_0_0ReactTag];                                                                    \
    if (![view isKindOfClass:[ABI50_0_0RNCWebViewImpl class]]) {                                                                                 \
      ABI50_0_0RCTLogError(@"Invalid view returned from registry, expecting ABI50_0_0RNCWebView, got: %@", view);                                         \
    } else {                                                                                                                            \
      [view name];                                                                                                                      \
    }                                                                                                                                   \
  }];                                                                                                                                   \
}
#define QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(name, in_param, out_param)                                                               \
ABI50_0_0RCT_EXPORT_METHOD(name:(nonnull NSNumber *)ABI50_0_0ReactTag in_param)                                                                           \
{                                                                                                                                       \
[self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, BASE_VIEW_PER_OS() *> *viewRegistry) {   \
    ABI50_0_0RNCWebViewImpl *view = (ABI50_0_0RNCWebViewImpl *)viewRegistry[ABI50_0_0ReactTag];                                                                    \
    if (![view isKindOfClass:[ABI50_0_0RNCWebViewImpl class]]) {                                                                                 \
      ABI50_0_0RCTLogError(@"Invalid view returned from registry, expecting ABI50_0_0RNCWebView, got: %@", view);                                         \
    } else {                                                                                                                            \
      [view name:out_param];                                                                                                            \
    }                                                                                                                                   \
  }];                                                                                                                                   \
}

QUICK_RCT_EXPORT_COMMAND_METHOD(reload)
QUICK_RCT_EXPORT_COMMAND_METHOD(goBack)
QUICK_RCT_EXPORT_COMMAND_METHOD(goForward)
QUICK_RCT_EXPORT_COMMAND_METHOD(stopLoading)
QUICK_RCT_EXPORT_COMMAND_METHOD(requestFocus)

QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(postMessage, message:(NSString *)message, message)
QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(injectJavaScript, script:(NSString *)script, script)
QUICK_RCT_EXPORT_COMMAND_METHOD_PARAMS(clearCache, includeDiskFiles:(BOOL)includeDiskFiles, includeDiskFiles)

ABI50_0_0RCT_EXPORT_METHOD(shouldStartLoadWithLockIdentifier:(BOOL)shouldStart
                                        lockIdentifier:(double)lockIdentifier)
{
    [[ABI50_0_0RNCWebViewDecisionManager getInstance] setResult:shouldStart forLockIdentifier:(int)lockIdentifier];
}

// Thanks to this guard, we won't compile this code when we build for the old architecture.
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<ABI50_0_0facebook::ABI50_0_0React::TurboModule>)getTurboModule:
    (const ABI50_0_0facebook::ABI50_0_0React::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<ABI50_0_0facebook::ABI50_0_0React::NativeRNCWebViewSpecJSI>(params);
}
#endif

@end
