#import <objc/runtime.h>

@interface ABI50_0_0REAUtils : NSObject
+ (void)swizzleMethod:(SEL)originalSelector
             forClass:(Class)originalClass
                 with:(SEL)newSelector
            fromClass:(Class)newClass;
@end
