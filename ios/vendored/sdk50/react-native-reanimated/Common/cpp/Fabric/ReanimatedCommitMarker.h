#pragma once
#ifdef ABI50_0_0RCT_NEW_ARCH_ENABLED

namespace ABI50_0_0reanimated {

// This class is used to mark shadow tree commit as coming from Reanimated.
// During the life of this object, isReanimatedCommit() will return true, false
// otherwise. isReanimatedCommit() value change is restricted to the thread that
// created the object.
class ReanimatedCommitMarker {
 public:
  ReanimatedCommitMarker();
  ~ReanimatedCommitMarker();

  static bool isReanimatedCommit();

 private:
  static thread_local bool reanimatedCommitFlag_;
};

} // namespace reanimated

#endif // ABI50_0_0RCT_NEW_ARCH_ENABLED
