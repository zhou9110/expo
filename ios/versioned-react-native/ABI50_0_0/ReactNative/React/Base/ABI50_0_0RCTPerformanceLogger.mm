/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <QuartzCore/QuartzCore.h>
#import <ABI50_0_0cxxreact/ABI50_0_0ReactMarker.h>
#include <unordered_map>

#import "ABI50_0_0RCTLog.h"
#import "ABI50_0_0RCTPerformanceLogger.h"
#import "ABI50_0_0RCTPerformanceLoggerLabels.h"
#import "ABI50_0_0RCTProfile.h"
#import "ABI50_0_0RCTRootView.h"

using namespace ABI50_0_0facebook::ABI50_0_0React;

@interface ABI50_0_0RCTPerformanceLogger () {
  int64_t _data[ABI50_0_0RCTPLSize][2];
  NSInteger _cookies[ABI50_0_0RCTPLSize];
}

@end

@implementation ABI50_0_0RCTPerformanceLogger

static const std::unordered_map<ABI50_0_0RCTPLTag, ABI50_0_0ReactMarker::ABI50_0_0ReactMarkerId> &getStartTagToABI50_0_0ReactMarkerIdMap()
{
  static std::unordered_map<ABI50_0_0RCTPLTag, ABI50_0_0ReactMarker::ABI50_0_0ReactMarkerId> StartTagToABI50_0_0ReactMarkerIdMap = {
      {ABI50_0_0RCTPLAppStartup, ABI50_0_0ReactMarker::APP_STARTUP_START},
      {ABI50_0_0RCTPLInitABI50_0_0ReactRuntime, ABI50_0_0ReactMarker::INIT_REACT_RUNTIME_START},
      {ABI50_0_0RCTPLScriptExecution, ABI50_0_0ReactMarker::RUN_JS_BUNDLE_START}};
  return StartTagToABI50_0_0ReactMarkerIdMap;
}

static const std::unordered_map<ABI50_0_0RCTPLTag, ABI50_0_0ReactMarker::ABI50_0_0ReactMarkerId> &getStopTagToABI50_0_0ReactMarkerIdMap()
{
  static std::unordered_map<ABI50_0_0RCTPLTag, ABI50_0_0ReactMarker::ABI50_0_0ReactMarkerId> StopTagToABI50_0_0ReactMarkerIdMap = {
      {ABI50_0_0RCTPLAppStartup, ABI50_0_0ReactMarker::APP_STARTUP_STOP},
      {ABI50_0_0RCTPLInitABI50_0_0ReactRuntime, ABI50_0_0ReactMarker::INIT_REACT_RUNTIME_STOP},
      {ABI50_0_0RCTPLScriptExecution, ABI50_0_0ReactMarker::RUN_JS_BUNDLE_STOP}};
  return StopTagToABI50_0_0ReactMarkerIdMap;
}

- (void)markStartForTag:(ABI50_0_0RCTPLTag)tag
{
#if ABI50_0_0RCT_PROFILE
  if (ABI50_0_0RCTProfileIsProfiling()) {
    NSString *label = ABI50_0_0RCTPLLabelForTag(tag);
    _cookies[tag] = ABI50_0_0RCTProfileBeginAsyncEvent(ABI50_0_0RCTProfileTagAlways, label, nil);
  }
#endif
  const NSTimeInterval currentTime = CACurrentMediaTime() * 1000;
  _data[tag][0] = currentTime;
  _data[tag][1] = 0;

  // Notify ABI50_0_0RN ABI50_0_0ReactMarker when hosting platform log for markers
  const auto &startTagToABI50_0_0ReactMarkerIdMap = getStartTagToABI50_0_0ReactMarkerIdMap();
  if (startTagToABI50_0_0ReactMarkerIdMap.find(tag) != startTagToABI50_0_0ReactMarkerIdMap.end()) {
    ABI50_0_0ReactMarker::logMarkerDone(startTagToABI50_0_0ReactMarkerIdMap.at(tag), currentTime);
  }
}

- (void)markStopForTag:(ABI50_0_0RCTPLTag)tag
{
#if ABI50_0_0RCT_PROFILE
  if (ABI50_0_0RCTProfileIsProfiling()) {
    NSString *label = ABI50_0_0RCTPLLabelForTag(tag);
    ABI50_0_0RCTProfileEndAsyncEvent(ABI50_0_0RCTProfileTagAlways, @"native", _cookies[tag], label, @"ABI50_0_0RCTPerformanceLogger");
  }
#endif
  const NSTimeInterval currentTime = CACurrentMediaTime() * 1000;
  if (_data[tag][0] != 0 && _data[tag][1] == 0) {
    _data[tag][1] = currentTime;
  } else {
    ABI50_0_0RCTLogInfo(@"Unbalanced calls start/end for tag %li", (unsigned long)tag);
  }

  // Notify ABI50_0_0RN ABI50_0_0ReactMarker when hosting platform log for markers
  const auto &stopTagToABI50_0_0ReactMarkerIdMap = getStopTagToABI50_0_0ReactMarkerIdMap();
  if (stopTagToABI50_0_0ReactMarkerIdMap.find(tag) != stopTagToABI50_0_0ReactMarkerIdMap.end()) {
    ABI50_0_0ReactMarker::logMarkerDone(stopTagToABI50_0_0ReactMarkerIdMap.at(tag), currentTime);
  }
}

- (void)setValue:(int64_t)value forTag:(ABI50_0_0RCTPLTag)tag
{
  _data[tag][0] = 0;
  _data[tag][1] = value;
}

- (void)addValue:(int64_t)value forTag:(ABI50_0_0RCTPLTag)tag
{
  _data[tag][0] = 0;
  _data[tag][1] += value;
}

- (void)appendStartForTag:(ABI50_0_0RCTPLTag)tag
{
  _data[tag][0] = CACurrentMediaTime() * 1000;
}

- (void)appendStopForTag:(ABI50_0_0RCTPLTag)tag
{
  if (_data[tag][0] != 0) {
    _data[tag][1] += CACurrentMediaTime() * 1000 - _data[tag][0];
    _data[tag][0] = 0;
  } else {
    ABI50_0_0RCTLogInfo(@"Unbalanced calls start/end for tag %li", (unsigned long)tag);
  }
}

- (NSArray<NSNumber *> *)valuesForTags
{
  NSMutableArray *result = [NSMutableArray array];
  for (NSUInteger index = 0; index < ABI50_0_0RCTPLSize; index++) {
    [result addObject:@(_data[index][0])];
    [result addObject:@(_data[index][1])];
  }
  return result;
}

- (int64_t)durationForTag:(ABI50_0_0RCTPLTag)tag
{
  return _data[tag][1] - _data[tag][0];
}

- (int64_t)valueForTag:(ABI50_0_0RCTPLTag)tag
{
  return _data[tag][1];
}

@end
