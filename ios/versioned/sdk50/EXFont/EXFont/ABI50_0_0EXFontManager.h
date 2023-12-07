// Copyright 2015-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0EXFont/ABI50_0_0EXFont.h>

@interface ABI50_0_0EXFontManager : NSObject

- (instancetype)init;
- (ABI50_0_0EXFont *)fontForName:(NSString *)name;
- (void)setFont:(ABI50_0_0EXFont *)font forName:(NSString *)name;

@end
