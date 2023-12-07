// Copyright 2015-present 650 Industries. All rights reserved.

#import "ABI50_0_0EXVersionedNetworkInterceptor.h"

#import <ABI50_0_0React/ABI50_0_0RCTHTTPRequestHandler.h>
#import <ABI50_0_0React/ABI50_0_0RCTInspector.h>
#import <ABI50_0_0React/ABI50_0_0RCTInspectorPackagerConnection.h>
#import <SocketRocket/SRWebSocket.h>

#import "ABI50_0_0ExpoModulesCore-Swift.h"

#pragma mark - ABI50_0_0RCTInspectorPackagerConnection category interface

@interface ABI50_0_0RCTInspectorPackagerConnection(sendWrappedEventToAllPages)

- (BOOL)isReadyToSend;
- (void)sendWrappedEventToAllPages:(NSString *)event;

@end

#pragma mark -

@interface ABI50_0_0EXVersionedNetworkInterceptor () <ABI50_0_0EXRequestCdpInterceptorDelegate>

@property (nonatomic, strong) ABI50_0_0RCTInspectorPackagerConnection *inspectorPackgerConnection;

@end

@implementation ABI50_0_0EXVersionedNetworkInterceptor

- (instancetype)initWithABI50_0_0RCTInspectorPackagerConnection:(ABI50_0_0RCTInspectorPackagerConnection *)inspectorPackgerConnection
{
  if (self = [super init]) {
    self.inspectorPackgerConnection = inspectorPackgerConnection;
    [ABI50_0_0EXRequestCdpInterceptor.shared setDelegate:self];

    Class requestInterceptorClass = [ABI50_0_0EXRequestInterceptorProtocol class];
    ABI50_0_0RCTSetCustomNSURLSessionConfigurationProvider(^{
      NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
      NSMutableArray<Class> *protocolClasses = [urlSessionConfiguration.protocolClasses mutableCopy];
      if (![protocolClasses containsObject:requestInterceptorClass]) {
        [protocolClasses insertObject:requestInterceptorClass atIndex:0];
      }
      urlSessionConfiguration.protocolClasses = protocolClasses;

      [urlSessionConfiguration setHTTPShouldSetCookies:YES];
      [urlSessionConfiguration setHTTPCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
      [urlSessionConfiguration setHTTPCookieStorage:[NSHTTPCookieStorage sharedHTTPCookieStorage]];
      return urlSessionConfiguration;
    });
  }
  return self;
}

- (void)dealloc
{
  [ABI50_0_0EXRequestCdpInterceptor.shared setDelegate:nil];
}

#pragma mark - ABI50_0_0EXRequestCdpInterceptorDelegate implementations

- (void)dispatch:(NSString * _Nonnull)event {
  [self.inspectorPackgerConnection sendWrappedEventToAllPages:event];
}

@end

#pragma mark - ABI50_0_0RCTInspectorPackagerConnection category

@interface ABI50_0_0RCTInspectorPackagerConnection(sendWrappedEventToAllPages)

- (BOOL)isReadyToSend;
- (void)sendWrappedEventToAllPages:(NSString *)event;

@end

#pragma mark - ABI50_0_0RCTInspectorPackagerConnection category implementation

@implementation ABI50_0_0RCTInspectorPackagerConnection(sendWrappedEventToAllPages)

- (BOOL)isReadyToSend
{
  if ([self isConnected]) {
    return YES;
  }

  SRWebSocket *websocket = [self valueForKey:@"_webSocket"];
  return websocket.readyState == SR_OPEN;
}

- (void)sendWrappedEventToAllPages:(NSString *)event
{
  if (![self isReadyToSend]) {
    return;
  }

  SEL selector = NSSelectorFromString(@"sendWrappedEvent:message:");
  if ([self respondsToSelector:selector]) {
    IMP sendWrappedEventIMP = [self methodForSelector:selector];
    void (*functor)(id, SEL, NSString *, NSString *) = (void *)sendWrappedEventIMP;
    for (ABI50_0_0RCTInspectorPage* page in ABI50_0_0RCTInspector.pages) {
      if (![page.title containsString:@"Reanimated"]) {
        functor(self, selector, [@(page.id) stringValue], event);
      }
    }
  }
}

@end
