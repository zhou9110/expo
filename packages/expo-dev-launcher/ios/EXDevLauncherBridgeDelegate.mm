#import <React/RCTRootView.h>

#import "EXDevLauncherController.h"
#import "EXDevLauncherRCTBridge.h"

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTFabricSurfaceHostingProxyRootView.h>
#import <React/RCTSurfacePresenter.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <ReactCommon/RCTTurboModuleManager.h>
#import <react/config/ReactNativeConfig.h>


static NSString *const kRNConcurrentRoot = @"concurrentRoot";

#endif

#import "React/RCTAppSetupUtils.h"


#if __has_include(<React-RCTAppDelegate/RCTAppDelegate.h>)
#import <React-RCTAppDelegate/RCTAppDelegate.h>
#elif __has_include(<React_RCTAppDelegate/RCTAppDelegate.h>)
// for importing the header from framework, the dash will be transformed to underscore
#import <React_RCTAppDelegate/RCTAppDelegate.h>
#endif

@interface EXDevLauncherBridgeDelegate: RCTAppDelegate
@end

@implementation EXDevLauncherBridgeDelegate : RCTAppDelegate

+ (RCTRootView *)createRootViewWithModuleName:(NSString *)moduleName launchOptions:(NSDictionary * _Nullable)launchOptions application:(UIApplication *)application{
    BOOL enableTM = NO;
    #if RCT_NEW_ARCH_ENABLED
        enableTM = YES;
    #endif

    RCTAppSetupPrepareApp(application, enableTM);


    RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:[EXDevLauncherController sharedInstance] launchOptions:launchOptions];

    #if RCT_NEW_ARCH_ENABLED
    facebook::react::ContextContainer::Shared _contextContainer;
    _contextContainer = std::make_shared<facebook::react::ContextContainer const>();

    std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
    _reactNativeConfig = std::make_shared<facebook::react::EmptyReactNativeConfig const>();
    _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);

    RCTSurfacePresenterBridgeAdapter *_bridgeAdapter;
    _bridgeAdapter = [[RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:bridge
                                                                contextContainer:_contextContainer];
    bridge.surfacePresenter = _bridgeAdapter.surfacePresenter;
    #endif

    NSMutableDictionary *initProps = [NSMutableDictionary new];
    #ifdef RCT_NEW_ARCH_ENABLED
      initProps[kRNConcurrentRoot] = @YES;
    #endif

    BOOL enableFabric = NO;
    #if RCT_NEW_ARCH_ENABLED
        enableFabric = TRUE;
    #endif

    return RCTAppSetupDefaultRootView(bridge, moduleName, initProps, enableFabric);

}

@end
