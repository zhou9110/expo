#import <ABI50_0_0RNReanimated/UIScheduler.h>
#import <ABI50_0_0React/ABI50_0_0RCTUIManager.h>
#import <ABI50_0_0ReactCommon/ABI50_0_0CallInvoker.h>

#include <memory>

namespace ABI50_0_0reanimated {

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0React;

class ABI50_0_0REAIOSUIScheduler : public UIScheduler {
 public:
  void scheduleOnUI(std::function<void()> job) override;
};

} // namespace reanimated
