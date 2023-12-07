/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <gtest/gtest.h>
#include <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0SchedulerPriorityUtils.h>
#include <ABI50_0_0React/renderer/runtimescheduler/ABI50_0_0Task.h>
#include <chrono>

using namespace ABI50_0_0facebook::ABI50_0_0React;

TEST(SchedulerPriorityTest, fromRawValue) {
  ABI50_0_0EXPECT_EQ(SchedulerPriority::ImmediatePriority, fromRawValue(1.0));
  ABI50_0_0EXPECT_EQ(SchedulerPriority::UserBlockingPriority, fromRawValue(2.0));
  ABI50_0_0EXPECT_EQ(SchedulerPriority::NormalPriority, fromRawValue(3.0));
  ABI50_0_0EXPECT_EQ(SchedulerPriority::LowPriority, fromRawValue(4.0));
  ABI50_0_0EXPECT_EQ(SchedulerPriority::IdlePriority, fromRawValue(5.0));
}

TEST(SchedulerPriorityTest, serialize) {
  ABI50_0_0EXPECT_EQ(serialize(SchedulerPriority::ImmediatePriority), 1);
  ABI50_0_0EXPECT_EQ(serialize(SchedulerPriority::UserBlockingPriority), 2);
  ABI50_0_0EXPECT_EQ(serialize(SchedulerPriority::NormalPriority), 3);
  ABI50_0_0EXPECT_EQ(serialize(SchedulerPriority::LowPriority), 4);
  ABI50_0_0EXPECT_EQ(serialize(SchedulerPriority::IdlePriority), 5);
}

TEST(SchedulerPriorityTest, timeoutForSchedulerPriority) {
  ABI50_0_0EXPECT_EQ(
      timeoutForSchedulerPriority(SchedulerPriority::ImmediatePriority),
      std::chrono::milliseconds(-1));
  ABI50_0_0EXPECT_EQ(
      timeoutForSchedulerPriority(SchedulerPriority::UserBlockingPriority),
      std::chrono::milliseconds(250));
  ABI50_0_0EXPECT_EQ(
      timeoutForSchedulerPriority(SchedulerPriority::NormalPriority),
      std::chrono::seconds(5));
  ABI50_0_0EXPECT_EQ(
      timeoutForSchedulerPriority(SchedulerPriority::LowPriority),
      std::chrono::seconds(10));
  ABI50_0_0EXPECT_EQ(
      timeoutForSchedulerPriority(SchedulerPriority::IdlePriority),
      std::chrono::milliseconds::max());
}
