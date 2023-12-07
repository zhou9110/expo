#import <Foundation/Foundation.h>
#import "ABI50_0_0RNCSafeAreaViewEdgeMode.h"

typedef struct ABI50_0_0RNCSafeAreaViewEdges {
  ABI50_0_0RNCSafeAreaViewEdgeMode top;
  ABI50_0_0RNCSafeAreaViewEdgeMode right;
  ABI50_0_0RNCSafeAreaViewEdgeMode bottom;
  ABI50_0_0RNCSafeAreaViewEdgeMode left;
} ABI50_0_0RNCSafeAreaViewEdges;

ABI50_0_0RNCSafeAreaViewEdges ABI50_0_0RNCSafeAreaViewEdgesMake(
    ABI50_0_0RNCSafeAreaViewEdgeMode top,
    ABI50_0_0RNCSafeAreaViewEdgeMode right,
    ABI50_0_0RNCSafeAreaViewEdgeMode bottom,
    ABI50_0_0RNCSafeAreaViewEdgeMode left);
