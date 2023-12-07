/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <optional>

#import <ABI50_0_0React/ABI50_0_0RCTBackedTextInputViewProtocol.h>
#import <ABI50_0_0React/renderer/components/iostextinput/ABI50_0_0primitives.h>

NS_ASSUME_NONNULL_BEGIN

void ABI50_0_0RCTCopyBackedTextInput(
    UIView<ABI50_0_0RCTBackedTextInputViewProtocol> *fromTextInput,
    UIView<ABI50_0_0RCTBackedTextInputViewProtocol> *toTextInput);

UITextAutocorrectionType ABI50_0_0RCTUITextAutocorrectionTypeFromOptionalBool(std::optional<bool> autoCorrect);

UITextAutocapitalizationType ABI50_0_0RCTUITextAutocapitalizationTypeFromAutocapitalizationType(
    ABI50_0_0facebook::ABI50_0_0React::AutocapitalizationType autocapitalizationType);

UIKeyboardAppearance ABI50_0_0RCTUIKeyboardAppearanceFromKeyboardAppearance(
    ABI50_0_0facebook::ABI50_0_0React::KeyboardAppearance keyboardAppearance);

UITextSpellCheckingType ABI50_0_0RCTUITextSpellCheckingTypeFromOptionalBool(std::optional<bool> spellCheck);

UITextFieldViewMode ABI50_0_0RCTUITextFieldViewModeFromTextInputAccessoryVisibilityMode(
    ABI50_0_0facebook::ABI50_0_0React::TextInputAccessoryVisibilityMode mode);

UIKeyboardType ABI50_0_0RCTUIKeyboardTypeFromKeyboardType(ABI50_0_0facebook::ABI50_0_0React::KeyboardType keyboardType);

UIReturnKeyType ABI50_0_0RCTUIReturnKeyTypeFromReturnKeyType(ABI50_0_0facebook::ABI50_0_0React::ReturnKeyType returnKeyType);

UITextContentType ABI50_0_0RCTUITextContentTypeFromString(const std::string &contentType);

UITextInputPasswordRules *ABI50_0_0RCTUITextInputPasswordRulesFromString(const std::string &passwordRules);

UITextSmartInsertDeleteType ABI50_0_0RCTUITextSmartInsertDeleteTypeFromOptionalBool(std::optional<bool> smartInsertDelete);

NS_ASSUME_NONNULL_END
