// Copyright 2015-present 650 Industries. All rights reserved.

#import <Foundation/Foundation.h>
#import <ABI50_0_0EXMediaLibrary/ABI50_0_0EXMediaLibrary.h>

typedef void(^ABI50_0_0EXSaveToLibraryCallback)(id asset, NSError *error);

@interface ABI50_0_0EXSaveToLibraryDelegate : NSObject

- (void)writeImage:(UIImage *)image withCallback:(ABI50_0_0EXSaveToLibraryCallback)callback;

- (void)writeVideo:(NSString *)movieUrl withCallback:(ABI50_0_0EXSaveToLibraryCallback) callback;

- (void)writeGIF:(NSURL *)gifUrl withCallback:(ABI50_0_0EXSaveToLibraryCallback)callback;

@end
