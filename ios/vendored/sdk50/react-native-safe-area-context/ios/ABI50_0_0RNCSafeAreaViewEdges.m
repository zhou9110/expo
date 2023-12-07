#import "ABI50_0_0RNCSafeAreaViewEdges.h"
#import <ABI50_0_0React/ABI50_0_0RCTConvert.h>
#import "ABI50_0_0RNCSafeAreaViewEdgeMode.h"

ABI50_0_0RNCSafeAreaViewEdges ABI50_0_0RNCSafeAreaViewEdgesMake(
    ABI50_0_0RNCSafeAreaViewEdgeMode top,
    ABI50_0_0RNCSafeAreaViewEdgeMode right,
    ABI50_0_0RNCSafeAreaViewEdgeMode bottom,
    ABI50_0_0RNCSafeAreaViewEdgeMode left)
{
  ABI50_0_0RNCSafeAreaViewEdges edges;
  edges.top = top;
  edges.left = left;
  edges.bottom = bottom;
  edges.right = right;
  return edges;
}

ABI50_0_0RNCSafeAreaViewEdges ABI50_0_0RNCSafeAreaViewEdgesMakeString(NSString *top, NSString *right, NSString *bottom, NSString *left)
{
  ABI50_0_0RNCSafeAreaViewEdges edges;
  edges.top = [ABI50_0_0RCTConvert ABI50_0_0RNCSafeAreaViewEdgeMode:top];
  edges.right = [ABI50_0_0RCTConvert ABI50_0_0RNCSafeAreaViewEdgeMode:right];
  edges.bottom = [ABI50_0_0RCTConvert ABI50_0_0RNCSafeAreaViewEdgeMode:bottom];
  edges.left = [ABI50_0_0RCTConvert ABI50_0_0RNCSafeAreaViewEdgeMode:left];
  return edges;
}

@implementation ABI50_0_0RCTConvert (ABI50_0_0RNCSafeAreaViewEdges)

ABI50_0_0RCT_CUSTOM_CONVERTER(
    ABI50_0_0RNCSafeAreaViewEdges,
    ABI50_0_0RNCSafeAreaViewEdges,
    ABI50_0_0RNCSafeAreaViewEdgesMakeString(json[@"top"], json[@"right"], json[@"bottom"], json[@"left"]))

@end
