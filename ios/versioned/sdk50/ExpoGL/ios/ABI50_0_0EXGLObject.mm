// Copyright 2016-present 650 Industries. All rights reserved.

#import <ABI50_0_0ExpoGL/ABI50_0_0EXGLObject.h>

@implementation ABI50_0_0EXGLObject

- (instancetype)initWithConfig:(NSDictionary *)config
{
  if ((self = [super init])) {
    _exglCtxId = [config[@"exglCtxId"] unsignedIntValue];
    _exglObjId = ABI50_0_0EXGLContextCreateObject(_exglCtxId);
  }
  return self;
}

- (void)dealloc
{
  if (_exglObjId != 0) {
    ABI50_0_0EXGLContextDestroyObject(_exglCtxId, _exglObjId);
  }
}

@end

