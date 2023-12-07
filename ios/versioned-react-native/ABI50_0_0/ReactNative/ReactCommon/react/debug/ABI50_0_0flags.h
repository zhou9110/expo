/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

//
// Preprocessor flags which control whether code meant for debugging the
// internals of ABI50_0_0React Native is included in the build. E.g. debug assertions.
//
// This flag is normally derived from NDEBUG, but may be set explicitly by
// defining `ABI50_0_0REACT_NATIVE_DEBUG` or `ABI50_0_0REACT_NATIVE_PRODUCTION`.
#if !(defined(ABI50_0_0REACT_NATIVE_DEBUG) || defined(ABI50_0_0REACT_NATIVE_PRODUCTION))
#ifdef NDEBUG
#define ABI50_0_0REACT_NATIVE_PRODUCTION
#else
#define ABI50_0_0REACT_NATIVE_DEBUG
#endif
#endif
