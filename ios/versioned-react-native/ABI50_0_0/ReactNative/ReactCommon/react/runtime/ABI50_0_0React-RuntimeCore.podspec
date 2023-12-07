# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "../../..", "package.json")))
version = package['version']



folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1 -Wno-comma -Wno-shorten-64-to-32 -Wno-gnu-zero-variadic-macro-arguments'
folly_version = '2022.05.16.00'
folly_dep_name = 'RCT-Folly/Fabric'
boost_compiler_flags = '-Wno-documentation'

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-RuntimeCore"
  s.version                = version
  s.summary                = "The React Native Runtime."
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.source_files           = "*.{cpp,h}", "nativeviewconfig/*.{cpp,h}"
  s.exclude_files          = "iostests/*", "tests/**/*.{cpp,h}"
  s.header_dir             = "ABI50_0_0react/runtime"
  s.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/Headers/Private/React-Core\" \"${PODS_TARGET_SRCROOT}/../..\"",
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
                                "GCC_WARN_PEDANTIC" => "YES" }
  s.compiler_flags       = folly_compiler_flags + ' ' + boost_compiler_flags

  if ENV['USE_FRAMEWORKS']
    s.header_mappings_dir     = './'
    s.module_name             = 'ABI50_0_0React_RuntimeCore'
  end

  s.dependency folly_dep_name, folly_version
  s.dependency "ABI50_0_0React-jsiexecutor"
  s.dependency "ABI50_0_0React-cxxreact"
  s.dependency "ABI50_0_0React-runtimeexecutor"
  s.dependency "glog"
  s.dependency "ABI50_0_0React-jsi"
  s.dependency "ABI50_0_0React-jserrorhandler"
  s.dependency "ABI50_0_0React-runtimescheduler"

  if ENV["USE_HERMES"] == nil || ENV["USE_HERMES"] == "1"
    s.dependency "ABI50_0_0hermes-engine"
  else
    s.dependency "ABI50_0_0React-jsc"
  end

end
