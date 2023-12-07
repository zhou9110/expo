#import <ABI50_0_0React/ABI50_0_0RCTBridge.h>
#import <ABI50_0_0React/ABI50_0_0RCTView.h>
#import <UIKit/UIKit.h>

#import "ABI50_0_0RNCSafeAreaViewEdges.h"
#import "ABI50_0_0RNCSafeAreaViewMode.h"

NS_ASSUME_NONNULL_BEGIN

@class ABI50_0_0RNCSafeAreaView;

@interface ABI50_0_0RNCSafeAreaView : ABI50_0_0RCTView

- (instancetype)initWithBridge:(ABI50_0_0RCTBridge *)bridge;

@property (nonatomic, assign) ABI50_0_0RNCSafeAreaViewMode mode;
@property (nonatomic, assign) ABI50_0_0RNCSafeAreaViewEdges edges;

@end

NS_ASSUME_NONNULL_END
