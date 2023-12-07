#import <Foundation/Foundation.h>
#import <ABI50_0_0RNReanimated/ABI50_0_0RNGestureHandlerStateManager.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#include <string>
#include <utility>
#include <vector>

namespace ABI50_0_0reanimated {

std::vector<std::pair<std::string, double>> measure(
    int viewTag,
    ABI50_0_0RCTUIManager *uiManager);
void scrollTo(
    int scrollViewTag,
    ABI50_0_0RCTUIManager *uiManager,
    double x,
    double y,
    bool animated);
void setGestureState(
    id<ABI50_0_0RNGestureHandlerStateManager> gestureHandlerStateManager,
    int handlerTag,
    int newState);

} // namespace reanimated
