#pragma once

#import <memory>
#import <string>

#import <Foundation/Foundation.h>

#import <ABI50_0_0React/ABI50_0_0RCTJavaScriptExecutor.h>
#import <ABI50_0_0React/ABI50_0_0RCTMessageThread.h>
#import <ABI50_0_0cxxreact/ABI50_0_0MessageQueueThread.h>

namespace ABI50_0_0facebook {
namespace ABI50_0_0React {

class ABI50_0_0REAMessageThread : public ABI50_0_0RCTMessageThread {
 public:
  using ABI50_0_0RCTMessageThread::ABI50_0_0RCTMessageThread;
  virtual void quitSynchronous() override;
};

} // namespace ABI50_0_0React
} // namespace ABI50_0_0facebook
