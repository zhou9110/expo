# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

# package.json
package = JSON.parse(File.read(File.join(__dir__, "..", "..", "package.json")))
version = package['version']



folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1 -DFOLLY_HAVE_CLOCK_GETTIME=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2022.05.16.00'
boost_compiler_flags = '-Wno-documentation'

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-hermes"
  s.version                = version
  s.summary                = "Hermes engine for React Native"
  s.homepage               = "https://reactnative.dev/"
  s.license                = package['license']
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.source_files           = "executor/*.{cpp,h}",
                             "inspector-modern/*.{cpp,h}",
                             "inspector-modern/chrome/*.{cpp,h}",
                             "inspector-modern/detail/*.{cpp,h}"
  s.public_header_files    = "executor/HermesExecutorFactory.h"
  s.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
  s.pod_target_xcconfig    = {
                               "HEADER_SEARCH_PATHS" => "\"${PODS_ROOT}/hermes-engine/destroot/include\" \"$(PODS_TARGET_SRCROOT)/..\" \"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/fmt/include\" \"$(PODS_ROOT)/libevent/include\"",
                               "CLANG_CXX_LANGUAGE_STANDARD" => "c++20"
                             }
  s.header_dir             = "ABI50_0_0reacthermes"
  s.dependency "ABI50_0_0React-cxxreact", version
  s.dependency "ABI50_0_0React-jsiexecutor", version
  s.dependency "ABI50_0_0React-jsinspector", version
  s.dependency "ABI50_0_0React-perflogger", version
  s.dependency "RCT-Folly", folly_version
  s.dependency "DoubleConversion"
  s.dependency 'fmt' , '~> 6.2.1'
  s.dependency "glog"
  s.dependency "RCT-Folly/Futures", folly_version
  s.dependency "ABI50_0_0hermes-engine"
  s.dependency "ABI50_0_0React-jsi"
end
