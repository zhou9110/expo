/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <gtest/gtest.h>
#include <hermes/ABI50_0_0hermes.h>
#include <ABI50_0_0jsi/ABI50_0_0jsi.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventPipe.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventQueueProcessor.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0StatePipe.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ValueFactoryEventPayload.h>

#include <memory>

namespace ABI50_0_0facebook::ABI50_0_0React {

class EventQueueProcessorTest : public testing::Test {
 protected:
  void SetUp() override {
    runtime_ = ABI50_0_0facebook::ABI50_0_0hermes::makeHermesRuntime();

    auto eventPipe = [this](
                         jsi::Runtime& /*runtime*/,
                         const EventTarget* /*eventTarget*/,
                         const std::string& type,
                         ABI50_0_0ReactEventPriority priority,
                         const EventPayload& /*payload*/) {
      eventTypes_.push_back(type);
      eventPriorities_.push_back(priority);
    };

    auto dummyEventPipeConclusion = [](jsi::Runtime& runtime) {};
    auto dummyStatePipe = [](const StateUpdate& stateUpdate) {};

    eventProcessor_ = std::make_unique<EventQueueProcessor>(
        eventPipe, dummyEventPipeConclusion, dummyStatePipe);
  }

  std::unique_ptr<ABI50_0_0facebook::ABI50_0_0hermes::HermesRuntime> runtime_;
  std::unique_ptr<EventQueueProcessor> eventProcessor_;
  std::vector<std::string> eventTypes_;
  std::vector<ABI50_0_0ReactEventPriority> eventPriorities_;
  ValueFactory dummyValueFactory_;
};

TEST_F(EventQueueProcessorTest, singleUnspecifiedEvent) {
  eventProcessor_->flushEvents(
      *runtime_,
      {RawEvent(
          "my type",
          std::make_shared<ValueFactoryEventPayload>(dummyValueFactory_),
          nullptr,
          RawEvent::Category::Unspecified)});

  ABI50_0_0EXPECT_EQ(eventPriorities_.size(), 1);
  ABI50_0_0EXPECT_EQ(eventTypes_[0], "my type");
  ABI50_0_0EXPECT_EQ(eventPriorities_[0], ABI50_0_0ReactEventPriority::Discrete);
}

TEST_F(EventQueueProcessorTest, continuousEvent) {
  eventProcessor_->flushEvents(
      *runtime_,
      {RawEvent(
           "touchStart",
           std::make_shared<ValueFactoryEventPayload>(dummyValueFactory_),
           nullptr,
           RawEvent::Category::ContinuousStart),
       RawEvent(
           "touchMove",
           std::make_shared<ValueFactoryEventPayload>(dummyValueFactory_),
           nullptr,
           RawEvent::Category::Unspecified),
       RawEvent(
           "touchEnd",
           std::make_shared<ValueFactoryEventPayload>(dummyValueFactory_),
           nullptr,
           RawEvent::Category::ContinuousEnd),
       RawEvent(
           "custom event",
           std::make_shared<ValueFactoryEventPayload>(dummyValueFactory_),
           nullptr,
           RawEvent::Category::Unspecified)});

  ABI50_0_0EXPECT_EQ(eventPriorities_.size(), 4);

  ABI50_0_0EXPECT_EQ(eventTypes_[0], "touchStart");
  ABI50_0_0EXPECT_EQ(eventPriorities_[0], ABI50_0_0ReactEventPriority::Discrete);

  ABI50_0_0EXPECT_EQ(eventTypes_[1], "touchMove");
  ABI50_0_0EXPECT_EQ(eventPriorities_[1], ABI50_0_0ReactEventPriority::Default);

  ABI50_0_0EXPECT_EQ(eventTypes_[2], "touchEnd");
  ABI50_0_0EXPECT_EQ(eventPriorities_[2], ABI50_0_0ReactEventPriority::Discrete);

  ABI50_0_0EXPECT_EQ(eventTypes_[3], "custom event");
  ABI50_0_0EXPECT_EQ(eventPriorities_[3], ABI50_0_0ReactEventPriority::Discrete);
}

TEST_F(EventQueueProcessorTest, alwaysContinuousEvent) {
  eventProcessor_->flushEvents(
      *runtime_,
      {
          RawEvent(
              "onScroll",
              std::make_shared<ValueFactoryEventPayload>(dummyValueFactory_),
              nullptr,
              RawEvent::Category::Continuous),
      });

  ABI50_0_0EXPECT_EQ(eventPriorities_.size(), 1);

  ABI50_0_0EXPECT_EQ(eventTypes_[0], "onScroll");
  ABI50_0_0EXPECT_EQ(eventPriorities_[0], ABI50_0_0ReactEventPriority::Default);
}

TEST_F(EventQueueProcessorTest, alwaysDiscreteEvent) {
  eventProcessor_->flushEvents(
      *runtime_,
      {
          RawEvent(
              "onChange",
              std::make_shared<ValueFactoryEventPayload>(dummyValueFactory_),
              nullptr,
              RawEvent::Category::Discrete),
      });

  ABI50_0_0EXPECT_EQ(eventPriorities_.size(), 1);

  ABI50_0_0EXPECT_EQ(eventTypes_[0], "onChange");
  ABI50_0_0EXPECT_EQ(eventPriorities_[0], ABI50_0_0ReactEventPriority::Discrete);
}

} // namespace ABI50_0_0facebook::ABI50_0_0React
