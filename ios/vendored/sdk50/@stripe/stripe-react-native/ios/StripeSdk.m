#import <ABI50_0_0React/ABI50_0_0RCTBridgeModule.h>
#import <ABI50_0_0React/ABI50_0_0RCTEventEmitter.h>

@interface ABI50_0_0RCT_EXTERN_REMAP_MODULE(StripeSdk, ABI50_0_0StripeSdk, ABI50_0_0RCTEventEmitter)


ABI50_0_0RCT_EXTERN_METHOD(
                  initialise:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  createToken: (NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  isPlatformPaySupported:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  createPlatformPayPaymentMethod:(NSDictionary *)params
                  usesDeprecatedTokenFlow:(BOOL)usesDeprecatedTokenFlow
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  confirmPlatformPay:(NSString *)clientSecret
                  params:(NSDictionary *)params
                  isPaymentIntent:(BOOL)isPaymentIntent
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  dismissPlatformPay: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  updatePlatformPaySheet:(NSArray *)summaryItems
                  shippingMethods:(NSArray *)summaryItems
                  errors: (NSArray *)errors
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  openApplePaySetup: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  createTokenForCVCUpdate:(NSString *)cvc
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  handleURLCallback:(NSString *)url
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  createPaymentMethod:(NSDictionary *)data
                  options:(NSDictionary *)options
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  retrievePaymentIntent:(NSString *)clientSecret
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  retrieveSetupIntent:(NSString *)clientSecret
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  handleNextAction:(NSString *)paymentIntentClientSecret
                  returnURL:(NSString *)returnURL
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  handleNextActionForSetup:(NSString *)setupIntentClientSecret
                  returnURL:(NSString *)returnURL
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  initPaymentSheet:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  intentCreationCallback:(NSDictionary *)result
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  presentPaymentSheet:(NSDictionary *)options
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  confirmPaymentSheetPayment:(ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  resetPaymentSheetCustomer:(ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  confirmPayment:(NSString *)paymentIntentClientSecret
                  data:(NSDictionary *)data
                  options:(NSDictionary *)options
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  confirmSetupIntent:(NSString *)setupIntentClientSecret
                  data:(NSDictionary *)data
                  options:(NSDictionary *)options
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  verifyMicrodeposits:(BOOL)isPaymentIntent
                  clientSecret:(NSString *)clientSecret
                  params:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )
ABI50_0_0RCT_EXTERN_METHOD(
                  collectBankAccount:(BOOL)isPaymentIntent
                  clientSecret:(NSString *)clientSecret
                  params:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )
ABI50_0_0RCT_EXTERN_METHOD(
                  canAddCardToWallet:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )
ABI50_0_0RCT_EXTERN_METHOD(
                  isCardInWallet:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )
ABI50_0_0RCT_EXTERN_METHOD(
                  collectBankAccountToken:(NSString *)clientSecret
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )
ABI50_0_0RCT_EXTERN_METHOD(
                  collectFinancialConnectionsAccounts:(NSString *)clientSecret
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )
ABI50_0_0RCT_EXTERN_METHOD(
                  configureOrderTracking:(NSString *)orderTypeIdentifier
                  orderIdentifier:(NSString *)orderIdentifier
                  webServiceUrl:(NSString *)webServiceUrl
                  authenticationToken:(NSString *)authenticationToken
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  initCustomerSheet:(NSDictionary *)params
                  customerAdapterOverrides: (NSDictionary *)customerAdapterOverrides
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  presentCustomerSheet:(NSDictionary *)params
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  retrieveCustomerSheetPaymentOptionSelection:(ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  customerAdapterFetchPaymentMethodsCallback:(NSArray *)paymentMethods
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  customerAdapterAttachPaymentMethodCallback:(NSDictionary *)unusedPaymentMethod
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  customerAdapterDetachPaymentMethodCallback:(NSDictionary *)unusedPaymentMethod
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  customerAdapterSetSelectedPaymentOptionCallback:(ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  customerAdapterFetchSelectedPaymentOptionCallback:(NSString *)paymentOption
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )

ABI50_0_0RCT_EXTERN_METHOD(
                  customerAdapterSetupIntentClientSecretForCustomerAttachCallback:(NSString *)clientSecret
                  resolver: (ABI50_0_0RCTPromiseResolveBlock)resolve
                  rejecter: (ABI50_0_0RCTPromiseRejectBlock)reject
                  )
@end
