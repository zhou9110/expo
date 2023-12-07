/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#include <memory>

#include <assert.h>
#include <gtest/gtest.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0AttributedString.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0TextAttributes.h>
#include <ABI50_0_0React/renderer/attributedstring/ABI50_0_0primitives.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0ParagraphState.h>
#include <ABI50_0_0React/renderer/components/text/ABI50_0_0conversions.h>

namespace ABI50_0_0facebook::ABI50_0_0React {

#ifdef ANDROID

TEST(ParagraphLocalDataTest, testSomething) {
  auto attributedString = AttributedString();
  auto fragment = AttributedString::Fragment();
  fragment.string = "test";

  auto text = TextAttributes();
  text.foregroundColor = {
      colorFromComponents({100 / 255.0, 153 / 255.0, 253 / 255.0, 1.0})};
  text.opacity = 0.5;
  text.fontStyle = FontStyle::Italic;
  text.fontWeight = FontWeight::Thin;
  text.fontVariant = FontVariant::TabularNums;
  fragment.textAttributes = text;
  attributedString.prependFragment(fragment);

  auto paragraphState = ParagraphState{};
  paragraphState.attributedString = attributedString;

  auto result = toDynamic(paragraphState)["attributedString"];

  ABI50_0_0EXPECT_EQ(result["string"], fragment.string);
  auto textAttribute = result["fragments"][0]["textAttributes"];
  ABI50_0_0EXPECT_EQ(textAttribute["foregroundColor"], toDynamic(text.foregroundColor));
  ABI50_0_0EXPECT_EQ(textAttribute["opacity"], text.opacity);
  ABI50_0_0EXPECT_EQ(textAttribute["fontStyle"], toString(*text.fontStyle));
  ABI50_0_0EXPECT_EQ(textAttribute["fontWeight"], toString(*text.fontWeight));
}

#endif

} // namespace ABI50_0_0facebook::ABI50_0_0React
