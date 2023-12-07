#import <ABI50_0_0RNReanimated/ABI50_0_0REAMessageThread.h>

#include <condition_variable>
#include <mutex>

#import <ABI50_0_0React/ABI50_0_0RCTCxxUtils.h>
#import <ABI50_0_0React/ABI50_0_0RCTMessageThread.h>
#import <ABI50_0_0React/ABI50_0_0RCTUtils.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {

// Essentially the same as ABI50_0_0RCTMessageThread, but with public fields.
struct ABI50_0_0REAMessageThreadPublic {
  // I don't know why we need three vtables (if you know then feel free to
  // explain it instead of this message), but this is what makes the casts in
  // quitSynchronous() work correctly.
  void *vtable1;
  void *vtable2;
  void *vtable3;
  CFRunLoopRef m_cfRunLoop;
  ABI50_0_0RCTJavaScriptCompleteBlock m_errorBlock;
  std::atomic_bool m_shutdown;
};

// We need to prevent any new code from being executed on the thread as there
// is an assertion for that in the destructor of ABI50_0_0RCTMessageThread, but we have
// to override quitSynchronous() as it would quit the main looper and freeze
// the app.
void ABI50_0_0REAMessageThread::quitSynchronous()
{
  ABI50_0_0RCTMessageThread *rctThread = static_cast<ABI50_0_0RCTMessageThread *>(this);
  ABI50_0_0REAMessageThreadPublic *rctThreadPublic = reinterpret_cast<ABI50_0_0REAMessageThreadPublic *>(rctThread);
  rctThreadPublic->m_shutdown = true;
}

} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
