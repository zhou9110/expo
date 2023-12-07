#import <Foundation/Foundation.h>

#import "ABI50_0_0RNSVGUIKit.h"

typedef enum ABI50_0_0RNSVGMarkerType { kStartMarker, kMidMarker, kEndMarker } ABI50_0_0RNSVGMarkerType;

#define ABI50_0_0RNSVGZEROPOINT CGRectZero.origin

@interface ABI50_0_0RNSVGMarkerPosition : NSObject

// Element storage
@property (nonatomic, assign) ABI50_0_0RNSVGMarkerType type;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) float angle;

// Instance creation
+ (instancetype)markerPosition:(ABI50_0_0RNSVGMarkerType)type origin:(CGPoint)origin angle:(float)angle;

+ (NSArray<ABI50_0_0RNSVGMarkerPosition *> *)fromCGPath:(CGPathRef)path;

@end
