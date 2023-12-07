/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <ABI50_0_0jsi/ABI50_0_0jsi.h>

@class ABI50_0_0RCTBlobManager;

namespace ABI50_0_0facebook::ABI50_0_0React {

class JSI_EXPORT ABI50_0_0RCTBlobCollector : public jsi::HostObject {
 public:
  ABI50_0_0RCTBlobCollector(ABI50_0_0RCTBlobManager *blobManager, const std::string &blobId);
  ~ABI50_0_0RCTBlobCollector();

  static void install(ABI50_0_0RCTBlobManager *blobManager);

 private:
  const std::string blobId_;
  ABI50_0_0RCTBlobManager *blobManager_;
};

} // namespace ABI50_0_0facebook::ABI50_0_0React
