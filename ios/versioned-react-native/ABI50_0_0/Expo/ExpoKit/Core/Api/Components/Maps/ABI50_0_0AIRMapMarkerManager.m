/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ABI50_0_0AIRMapMarkerManager.h"

#import <ABI50_0_0React/ABI50_0_0RCTConvert+CoreLocation.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>
#import "ABI50_0_0AIRMapMarker.h"

@interface ABI50_0_0AIRMapMarkerManager () <MKMapViewDelegate>

@end

@implementation ABI50_0_0AIRMapMarkerManager

ABI50_0_0RCT_EXPORT_MODULE()

- (UIView *)view
{
    ABI50_0_0AIRMapMarker *marker = [ABI50_0_0AIRMapMarker new];
    [marker addTapGestureRecognizer];
    marker.bridge = self.bridge;
    marker.isAccessibilityElement = YES;
    marker.accessibilityElementsHidden = NO;
    return marker;
}

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(identifier, NSString)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(testID, accessibilityIdentifier, NSString)
//ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(reuseIdentifier, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(title, NSString)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(description, subtitle, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(coordinate, CLLocationCoordinate2D)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(centerOffset, CGPoint)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(calloutOffset, CGPoint)
ABI50_0_0RCT_REMAP_VIEW_PROPERTY(image, imageSrc, NSString)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(pinColor, UIColor)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(draggable, BOOL)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(zIndex, NSInteger)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(opacity, double)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(isPreselected, BOOL)

ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onPress, ABI50_0_0RCTBubblingEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onSelect, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onDeselect, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onCalloutPress, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onDragStart, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onDrag, ABI50_0_0RCTDirectEventBlock)
ABI50_0_0RCT_EXPORT_VIEW_PROPERTY(onDragEnd, ABI50_0_0RCTDirectEventBlock)


ABI50_0_0RCT_EXPORT_METHOD(showCallout:(nonnull NSNumber *)ABI50_0_0ReactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        id view = viewRegistry[ABI50_0_0ReactTag];
        if (![view isKindOfClass:[ABI50_0_0AIRMapMarker class]]) {
            ABI50_0_0RCTLogError(@"Invalid view returned from registry, expecting ABI50_0_0AIRMap, got: %@", view);
        } else {
            [(ABI50_0_0AIRMapMarker *) view showCalloutView];
        }
    }];
}

ABI50_0_0RCT_EXPORT_METHOD(hideCallout:(nonnull NSNumber *)ABI50_0_0ReactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        id view = viewRegistry[ABI50_0_0ReactTag];
        if (![view isKindOfClass:[ABI50_0_0AIRMapMarker class]]) {
            ABI50_0_0RCTLogError(@"Invalid view returned from registry, expecting ABI50_0_0AIRMap, got: %@", view);
        } else {
            [(ABI50_0_0AIRMapMarker *) view hideCalloutView];
        }
    }];
}

ABI50_0_0RCT_EXPORT_METHOD(redrawCallout:(nonnull NSNumber *)ABI50_0_0ReactTag)
{
    [self.bridge.uiManager addUIBlock:^(__unused ABI50_0_0RCTUIManager *uiManager, NSDictionary<NSNumber *, UIView *> *viewRegistry) {
        id view = viewRegistry[ABI50_0_0ReactTag];
        if (![view isKindOfClass:[ABI50_0_0AIRMapMarker class]]) {
            ABI50_0_0RCTLogError(@"Invalid view returned from registry, expecting ABI50_0_0AIRMap, got: %@", view);
        } else {
            //no need to do anything here
        }
    }];
}

@end
