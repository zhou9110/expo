/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <ABI50_0_0yoga/ABI50_0_0YGEnums.h>
#include <ABI50_0_0yoga/ABI50_0_0YGMacros.h>

ABI50_0_0YG_EXTERN_C_BEGIN

typedef struct ABI50_0_0YGValue {
  float value;
  ABI50_0_0YGUnit unit;
} ABI50_0_0YGValue;

ABI50_0_0YG_EXPORT extern const ABI50_0_0YGValue ABI50_0_0YGValueAuto;
ABI50_0_0YG_EXPORT extern const ABI50_0_0YGValue ABI50_0_0YGValueUndefined;
ABI50_0_0YG_EXPORT extern const ABI50_0_0YGValue ABI50_0_0YGValueZero;

ABI50_0_0YG_EXTERN_C_END

#ifdef __cplusplus
#include <limits>
constexpr float ABI50_0_0YGUndefined = std::numeric_limits<float>::quiet_NaN();
#else
#include <math.h>
#define ABI50_0_0YGUndefined NAN
#endif

#ifdef __cplusplus
inline bool operator==(const ABI50_0_0YGValue& lhs, const ABI50_0_0YGValue& rhs) {
  if (lhs.unit != rhs.unit) {
    return false;
  }

  switch (lhs.unit) {
    case ABI50_0_0YGUnitUndefined:
    case ABI50_0_0YGUnitAuto:
      return true;
    case ABI50_0_0YGUnitPoint:
    case ABI50_0_0YGUnitPercent:
      return lhs.value == rhs.value;
  }

  return false;
}

inline bool operator!=(const ABI50_0_0YGValue& lhs, const ABI50_0_0YGValue& rhs) {
  return !(lhs == rhs);
}

inline ABI50_0_0YGValue operator-(const ABI50_0_0YGValue& value) {
  return {-value.value, value.unit};
}
#endif
