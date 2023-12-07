// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI50_0_0EXBarCodeScanner/ABI50_0_0EXBarCodeScannerProvider.h>
#import <ABI50_0_0EXBarCodeScanner/ABI50_0_0EXBarCodeScanner.h>
#import <ABI50_0_0ExpoModulesCore/ABI50_0_0EXDefines.h>

@implementation ABI50_0_0EXBarCodeScannerProvider

ABI50_0_0EX_REGISTER_MODULE();

+ (const NSArray<Protocol *> *)exportedInterfaces
{
  return @[@protocol(ABI50_0_0EXBarCodeScannerProviderInterface)];
}

- (id<ABI50_0_0EXBarCodeScannerInterface>)createBarCodeScanner
{
  return [ABI50_0_0EXBarCodeScanner new];
}

@end
