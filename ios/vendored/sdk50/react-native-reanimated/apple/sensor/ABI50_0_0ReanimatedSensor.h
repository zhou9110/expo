#if !TARGET_OS_TV && !TARGET_OS_OSX
#import <CoreMotion/CoreMotion.h>
#endif
#import <ABI50_0_0RNReanimated/ABI50_0_0ReanimatedSensorType.h>

@interface ABI50_0_0ReanimatedSensor : NSObject {
  ABI50_0_0ReanimatedSensorType _sensorType;
  double _interval;
  double _lastTimestamp;
  int _referenceFrame;
#if !TARGET_OS_TV && !TARGET_OS_OSX
  CMMotionManager *_motionManager;
#endif
  void (^_setter)(double[], int);
}

- (instancetype)init:(ABI50_0_0ReanimatedSensorType)sensorType
             interval:(int)interval
    iosReferenceFrame:(int)iosReferenceFrame
               setter:(void (^)(double[], int))setter;
- (bool)initialize;
- (bool)initializeGyroscope;
- (bool)initializeAccelerometer;
- (bool)initializeGravity;
- (bool)initializeMagnetometer;
- (bool)initializeOrientation;
- (void)cancel;

@end
