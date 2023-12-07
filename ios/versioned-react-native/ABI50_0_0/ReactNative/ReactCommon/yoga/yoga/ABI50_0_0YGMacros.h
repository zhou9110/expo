/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#ifdef __cplusplus
#include <type_traits>
#endif

#ifdef __cplusplus
#define ABI50_0_0YG_EXTERN_C_BEGIN extern "C" {
#define ABI50_0_0YG_EXTERN_C_END }
#else
#define ABI50_0_0YG_EXTERN_C_BEGIN
#define ABI50_0_0YG_EXTERN_C_END
#endif

#if defined(__cplusplus)
#define ABI50_0_0YG_DEPRECATED(message) [[deprecated(message)]]
#elif defined(_MSC_VER)
#define ABI50_0_0YG_DEPRECATED(message) __declspec(deprecated(message))
#else
#define ABI50_0_0YG_DEPRECATED(message) __attribute__((deprecated(message)))
#endif

#ifdef _WINDLL
#define ABI50_0_0YG_EXPORT __declspec(dllexport)
#elif !defined(_MSC_VER)
#define ABI50_0_0YG_EXPORT __attribute__((visibility("default")))
#else
#define ABI50_0_0YG_EXPORT
#endif

#ifdef NS_ENUM
// Cannot use NSInteger as NSInteger has a different size than int (which is the
// default type of a enum). Therefor when linking the Yoga C library into obj-c
// the header is a mismatch for the Yoga ABI.
#define ABI50_0_0YG_ENUM_BEGIN(name) NS_ENUM(int, name)
#define ABI50_0_0YG_ENUM_END(name)
#else
#define ABI50_0_0YG_ENUM_BEGIN(name) enum name
#define ABI50_0_0YG_ENUM_END(name) name
#endif

#ifdef __cplusplus
#define ABI50_0_0YG_DEFINE_ENUM_FLAG_OPERATORS(name)                       \
  extern "C++" {                                                  \
  constexpr inline name operator~(name a) {                       \
    return static_cast<name>(                                     \
        ~static_cast<std::underlying_type<name>::type>(a));       \
  }                                                               \
  constexpr inline name operator|(name a, name b) {               \
    return static_cast<name>(                                     \
        static_cast<std::underlying_type<name>::type>(a) |        \
        static_cast<std::underlying_type<name>::type>(b));        \
  }                                                               \
  constexpr inline name operator&(name a, name b) {               \
    return static_cast<name>(                                     \
        static_cast<std::underlying_type<name>::type>(a) &        \
        static_cast<std::underlying_type<name>::type>(b));        \
  }                                                               \
  constexpr inline name operator^(name a, name b) {               \
    return static_cast<name>(                                     \
        static_cast<std::underlying_type<name>::type>(a) ^        \
        static_cast<std::underlying_type<name>::type>(b));        \
  }                                                               \
  inline name& operator|=(name& a, name b) {                      \
    return reinterpret_cast<name&>(                               \
        reinterpret_cast<std::underlying_type<name>::type&>(a) |= \
        static_cast<std::underlying_type<name>::type>(b));        \
  }                                                               \
  inline name& operator&=(name& a, name b) {                      \
    return reinterpret_cast<name&>(                               \
        reinterpret_cast<std::underlying_type<name>::type&>(a) &= \
        static_cast<std::underlying_type<name>::type>(b));        \
  }                                                               \
  inline name& operator^=(name& a, name b) {                      \
    return reinterpret_cast<name&>(                               \
        reinterpret_cast<std::underlying_type<name>::type&>(a) ^= \
        static_cast<std::underlying_type<name>::type>(b));        \
  }                                                               \
  }
#else
#define ABI50_0_0YG_DEFINE_ENUM_FLAG_OPERATORS(name)
#endif

#ifdef __cplusplus

namespace ABI50_0_0facebook::yoga {

template <typename T>
constexpr int
ordinalCount(); // can't use `= delete` due to a defect in clang < 3.9

namespace detail {
template <int... xs>
constexpr int n() {
  return sizeof...(xs);
}
} // namespace detail

} // namespace ABI50_0_0facebook::yoga
#endif

#define ABI50_0_0YG_ENUM_DECL(NAME, ...)                               \
  typedef ABI50_0_0YG_ENUM_BEGIN(NAME){__VA_ARGS__} ABI50_0_0YG_ENUM_END(NAME); \
  ABI50_0_0YG_EXPORT const char* NAME##ToString(NAME);

#ifdef __cplusplus
#define ABI50_0_0YG_ENUM_SEQ_DECL(NAME, ...)    \
  ABI50_0_0YG_ENUM_DECL(NAME, __VA_ARGS__)      \
  ABI50_0_0YG_EXTERN_C_END                      \
                                       \
  namespace ABI50_0_0facebook::yoga {           \
  template <>                          \
  constexpr int ordinalCount<NAME>() { \
    return detail::n<__VA_ARGS__>();   \
  }                                    \
  }                                    \
  ABI50_0_0YG_EXTERN_C_BEGIN
#else
#define ABI50_0_0YG_ENUM_SEQ_DECL ABI50_0_0YG_ENUM_DECL
#endif
