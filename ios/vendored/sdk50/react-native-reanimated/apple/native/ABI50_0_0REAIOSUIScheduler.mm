#import <ABI50_0_0RNReanimated/ABI50_0_0REAIOSUIScheduler.h>

namespace ABI50_0_0reanimated {

using namespace ABI50_0_0facebook;
using namespace ABI50_0_0React;

void ABI50_0_0REAIOSUIScheduler::scheduleOnUI(std::function<void()> job)
{
  if ([NSThread isMainThread]) {
    job();
    return;
  }

  UIScheduler::scheduleOnUI(job);

  if (!scheduledOnUI_) {
    dispatch_async(dispatch_get_main_queue(), ^{
      triggerUI();
    });
  }
}

} // namespace reanimated
