/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#pragma once

#include <memory>

#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0TextAttributes.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0Sealable.h>
#include <ABI50_0_0React/renderer/core/ABI50_0_0ShadowNode.h>
#include <ABI50_0_0React/renderer/debug/ABI50_0_0DebugStringConvertible.h>
#include <ABI50_0_0React/renderer/mounting/ABI50_0_0ShadowView.h>
#include <ABI50_0_0React/utils/ABI50_0_0hash_combine.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

class AttributedString;

using SharedAttributedString = std::shared_ptr<const AttributedString>;

/*
 * Simple, cross-platform, ABI50_0_0React-specific implementation of attributed string
 * (aka spanned string).
 * `AttributedString` is basically a list of `Fragments` which have `string` and
 * `textAttributes` + `shadowNode` associated with the `string`.
 */
class AttributedString : public Sealable, public DebugStringConvertible {
 public:
  class Fragment {
   public:
    static std::string AttachmentCharacter();

    std::string string;
    TextAttributes textAttributes;
    ShadowView parentShadowView;

    /*
     * Returns true is the Fragment represents an attachment.
     * Equivalent to `string == AttachmentCharacter()`.
     */
    bool isAttachment() const;

    /*
     * Returns whether the underlying text and attributes are equal,
     * disregarding layout or other information.
     */
    bool isContentEqual(const Fragment& rhs) const;

    bool operator==(const Fragment& rhs) const;
    bool operator!=(const Fragment& rhs) const;
  };

  class Range {
   public:
    int location{0};
    int length{0};
  };

  using Fragments = std::vector<Fragment>;

  /*
   * Appends and prepends a `fragment` to the string.
   */
  void appendFragment(const Fragment& fragment);
  void prependFragment(const Fragment& fragment);

  /*
   * Appends and prepends an `attributedString` (all its fragments) to
   * the string.
   */
  void appendAttributedString(const AttributedString& attributedString);
  void prependAttributedString(const AttributedString& attributedString);

  /*
   * Returns a read-only reference to a list of fragments.
   */
  const Fragments& getFragments() const;

  /*
   * Returns a reference to a list of fragments.
   */
  Fragments& getFragments();

  /*
   * Returns a string constructed from all strings in all fragments.
   */
  std::string getString() const;

  /*
   * Returns `true` if the string is empty (has no any fragments).
   */
  bool isEmpty() const;

  /**
   * Compares equality of TextAttributes of all Fragments on both sides.
   */
  bool compareTextAttributesWithoutFrame(const AttributedString& rhs) const;

  bool isContentEqual(const AttributedString& rhs) const;

  bool operator==(const AttributedString& rhs) const;
  bool operator!=(const AttributedString& rhs) const;

#pragma mark - DebugStringConvertible

#if ABI50_0_0RN_DEBUG_STRING_CONVERTIBLE
  SharedDebugStringConvertibleList getDebugChildren() const override;
#endif

 private:
  Fragments fragments_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React

namespace std {
template <>
struct hash<ABI50_0_0facebook::ABI50_0_0React::AttributedString::Fragment> {
  size_t operator()(
      const ABI50_0_0facebook::ABI50_0_0React::AttributedString::Fragment& fragment) const {
    return ABI50_0_0facebook::ABI50_0_0React::hash_combine(
        fragment.string,
        fragment.textAttributes,
        fragment.parentShadowView,
        fragment.parentShadowView.layoutMetrics);
  }
};

template <>
struct hash<ABI50_0_0facebook::ABI50_0_0React::AttributedString> {
  size_t operator()(
      const ABI50_0_0facebook::ABI50_0_0React::AttributedString& attributedString) const {
    auto seed = size_t{0};

    for (const auto& fragment : attributedString.getFragments()) {
      ABI50_0_0facebook::ABI50_0_0React::hash_combine(seed, fragment);
    }

    return seed;
  }
};
} // namespace std
