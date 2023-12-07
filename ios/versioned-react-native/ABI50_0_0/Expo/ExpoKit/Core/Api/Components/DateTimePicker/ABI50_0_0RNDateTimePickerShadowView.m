#import "ABI50_0_0RNDateTimePickerShadowView.h"

@implementation ABI50_0_0RNDateTimePickerShadowView

- (instancetype)init
{
  if (self = [super init]) {
    ABI50_0_0YGNodeSetMeasureFunc(self.yogaNode, ABI50_0_0RNDateTimePickerShadowViewMeasure);
  }
  return self;
}

- (void)setDate:(NSDate *)date {
  _date = date;
  ABI50_0_0YGNodeMarkDirty(self.yogaNode);
}

- (void)setLocale:(NSLocale *)locale {
  _locale = locale;
  ABI50_0_0YGNodeMarkDirty(self.yogaNode);
}

- (void)setMode:(UIDatePickerMode)mode {
  _mode = mode;
  ABI50_0_0YGNodeMarkDirty(self.yogaNode);
}


- (void)setDisplayIOS:(UIDatePickerStyle)displayIOS {
  _displayIOS = displayIOS;
  ABI50_0_0YGNodeMarkDirty(self.yogaNode);
}

- (void)setTimeZoneOffsetInMinutes:(NSInteger)timeZoneOffsetInMinutes {
  _timeZoneOffsetInMinutes = timeZoneOffsetInMinutes;
  ABI50_0_0YGNodeMarkDirty(self.yogaNode);
}

- (void)setTimeZoneName:(NSString *)timeZoneName {
  _timeZoneName = timeZoneName;
  ABI50_0_0YGNodeMarkDirty(self.yogaNode);
}

static ABI50_0_0YGSize ABI50_0_0RNDateTimePickerShadowViewMeasure(ABI50_0_0YGNodeConstRef node,
                                                float width,
                                                ABI50_0_0YGMeasureMode widthMode,
                                                float height,
                                                ABI50_0_0YGMeasureMode heightMode)
{
  ABI50_0_0RNDateTimePickerShadowView *shadowPickerView = (__bridge ABI50_0_0RNDateTimePickerShadowView *)ABI50_0_0YGNodeGetContext(node);

  __block CGSize size;
  dispatch_sync(dispatch_get_main_queue(), ^{
    [shadowPickerView.picker setDate:shadowPickerView.date];
    [shadowPickerView.picker setDatePickerMode:shadowPickerView.mode];
    [shadowPickerView.picker setLocale:shadowPickerView.locale];
    [shadowPickerView.picker setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:shadowPickerView.timeZoneOffsetInMinutes * 60]];

    if (shadowPickerView.timeZoneName) {
      NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:shadowPickerView.timeZoneName];
      if (timeZone != nil) {
        [shadowPickerView.picker setTimeZone:timeZone];
      } else {
        ABI50_0_0RCTLogWarn(@"'%@' does not exist in NSTimeZone.knownTimeZoneNames. Falling back to localTimeZone=%@", shadowPickerView.timeZoneName, NSTimeZone.localTimeZone.name);
        [shadowPickerView.picker setTimeZone:NSTimeZone.localTimeZone];
      }
    } else {
      [shadowPickerView.picker setTimeZone:NSTimeZone.localTimeZone];
    }

    if (@available(iOS 14.0, *)) {
      [shadowPickerView.picker setPreferredDatePickerStyle:shadowPickerView.displayIOS];
    }

    size = [shadowPickerView.picker sizeThatFits:UILayoutFittingCompressedSize];
    size.width += 10;
  });

  return (ABI50_0_0YGSize){
    ABI50_0_0RCTYogaFloatFromCoreGraphicsFloat(size.width),
    ABI50_0_0RCTYogaFloatFromCoreGraphicsFloat(size.height)
  };
}

@end
