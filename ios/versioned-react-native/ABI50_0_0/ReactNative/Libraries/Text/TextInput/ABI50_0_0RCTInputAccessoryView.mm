/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0React/ABI50_0_0RCTInputAccessoryView.h>

#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTTouchHandler.h>
#import <ABI50_0_0React/ABI50_0_0UIView+React.h>

#import <ABI50_0_0React/ABI50_0_0RCTInputAccessoryViewContent.h>

@interface ABI50_0_0RCTInputAccessoryView ()

// Overriding `inputAccessoryView` to `readwrite`.
@property (nonatomic, readwrite, retain) UIView *inputAccessoryView;

@end

@implementation ABI50_0_0RCTInputAccessoryView {
  BOOL _shouldBecomeFirstResponder;
}

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge
{
  if (self = [super init]) {
    _inputAccessoryView = [ABI50_0_0RCTInputAccessoryViewContent new];
    ABI50_0_0RCTTouchHandler *const touchHandler = [[ABI50_0_0RCTTouchHandler alloc] initWithBridge:bridge];
    [touchHandler attachToView:_inputAccessoryView];
  }
  return self;
}

- (BOOL)canBecomeFirstResponder
{
  return true;
}

- (void)ABI50_0_0ReactSetFrame:(CGRect)frame
{
  [_inputAccessoryView ABI50_0_0ReactSetFrame:frame];

  if (_shouldBecomeFirstResponder) {
    _shouldBecomeFirstResponder = NO;
    [self becomeFirstResponder];
  }
}

- (void)insertABI50_0_0ReactSubview:(UIView *)subview atIndex:(NSInteger)index
{
  [super insertABI50_0_0ReactSubview:subview atIndex:index];
  [_inputAccessoryView insertABI50_0_0ReactSubview:subview atIndex:index];
}

- (void)removeABI50_0_0ReactSubview:(UIView *)subview
{
  [super removeABI50_0_0ReactSubview:subview];
  [_inputAccessoryView removeABI50_0_0ReactSubview:subview];
}

- (void)didUpdateABI50_0_0ReactSubviews
{
  // Do nothing, as subviews are managed by `insertABI50_0_0ReactSubview:atIndex:`.
}

- (void)didSetProps:(NSArray<NSString *> *)changedProps
{
  // If the accessory view is not linked to a text input via nativeID, assume it is
  // a standalone component that should get focus whenever it is rendered.
  if (![changedProps containsObject:@"nativeID"] && !self.nativeID) {
    _shouldBecomeFirstResponder = YES;
  }
}

@end
