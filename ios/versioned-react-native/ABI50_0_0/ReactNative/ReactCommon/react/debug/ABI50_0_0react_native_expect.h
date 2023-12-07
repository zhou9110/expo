/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

// No header guards since it is legitimately possible to include this file more
// than once with and without ABI50_0_0REACT_NATIVE_DEBUG.

// ABI50_0_0React_native_expect is a non-fatal counterpart of ABI50_0_0React_native_assert.
// In debug builds, when an expectation fails, we log and move on.
// In release builds, ABI50_0_0React_native_expect is a noop.

// ABI50_0_0React_native_expect is appropriate for recoverable conditions that can be
// violated by user mistake (e.g. JS code passes an unexpected prop value).
// To enforce invariants that are internal to ABI50_0_0React Native, consider
// ABI50_0_0React_native_assert (or a stronger mechanism).
// Calling ABI50_0_0React_native_expect does NOT, by itself, guarantee that the user
// will see a helpful diagnostic (beyond a low level log). That concern is the
// caller's responsibility.

#include "ABI50_0_0flags.h"

#undef ABI50_0_0React_native_expect

#ifndef ABI50_0_0REACT_NATIVE_DEBUG

#define ABI50_0_0React_native_expect(e) ((void)0)

#else // ABI50_0_0REACT_NATIVE_DEBUG

#include <glog/logging.h>
#include <cassert>

#define ABI50_0_0React_native_expect(cond)                           \
  if (!(cond)) {                                            \
    LOG(ERROR) << "ABI50_0_0React_native_expect failure: " << #cond; \
  }

#endif // ABI50_0_0REACT_NATIVE_DEBUG
