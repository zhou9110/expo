/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <folly/dynamic.h>
#include <ABI50_0_0React/renderer/components/view/ABI50_0_0ViewEventEmitter.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0EventEmitter.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class ScrollViewMetrics {
 public:
  Size contentSize;
  Point contentOffset;
  EdgeInsets contentInset;
  Size containerSize;
  Float zoomScale;
};

class ScrollViewEventEmitter : public ViewEventEmitter {
 public:
  using ViewEventEmitter::ViewEventEmitter;

  void onScroll(const ScrollViewMetrics& scrollViewMetrics) const;
  void onScrollBeginDrag(const ScrollViewMetrics& scrollViewMetrics) const;
  void onScrollEndDrag(const ScrollViewMetrics& scrollViewMetrics) const;
  void onMomentumScrollBegin(const ScrollViewMetrics& scrollViewMetrics) const;
  void onMomentumScrollEnd(const ScrollViewMetrics& scrollViewMetrics) const;

 private:
  void dispatchScrollViewEvent(
      std::string name,
      const ScrollViewMetrics& scrollViewMetrics,
      EventPriority priority = EventPriority::AsynchronousBatched) const;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
