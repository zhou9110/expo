# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "../../../../..", "package.json")))
version = package['version']



folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1 -Wno-comma -Wno-shorten-64-to-32 -Wno-gnu-zero-variadic-macro-arguments'
folly_version = '2022.05.16.00'
folly_dep_name = 'RCT-Folly/Fabric'
boost_compiler_flags = '-Wno-documentation'

header_search_paths = [
  "$(PODS_ROOT)/boost",
  "$(PODS_ROOT)/Headers/Private/React-Core",
  "$(PODS_TARGET_SRCROOT)/../../../..",
  "$(PODS_TARGET_SRCROOT)/../../../../..",
]

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-RuntimeApple"
  s.version                = version
  s.summary                = "The React Native Runtime."
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.source_files           = "ReactCommon/*.{mm,h}"
  s.header_dir             = "ABI50_0_0ReactCommon"
  s.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => header_search_paths,
                                "USE_HEADERMAP" => "YES",
                                "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
                                "GCC_WARN_PEDANTIC" => "YES" }
  s.compiler_flags       = folly_compiler_flags + ' ' + boost_compiler_flags

  if ENV['USE_FRAMEWORKS']
    s.header_mappings_dir     = './'
    s.module_name             = 'ABI50_0_0React_RuntimeApple'
  end

  s.dependency folly_dep_name, folly_version
  s.dependency "ABI50_0_0React-jsiexecutor"
  s.dependency "ABI50_0_0React-cxxreact"
  s.dependency "ABI50_0_0React-callinvoker"
  s.dependency "ABI50_0_0React-runtimeexecutor"
  s.dependency "ABI50_0_0React-utils"
  s.dependency "ABI50_0_0React-jsi"
  s.dependency "ABI50_0_0React-Core/Default"
  s.dependency "ABI50_0_0React-CoreModules"
  s.dependency "ABI50_0_0React-NativeModulesApple"
  s.dependency "ABI50_0_0React-RCTFabric"
  s.dependency "ABI50_0_0React-RuntimeCore"
  s.dependency "ABI50_0_0React-Mapbuffer"
  s.dependency "ABI50_0_0React-jserrorhandler"

  if ENV["USE_HERMES"] == nil || ENV["USE_HERMES"] == "1"
    s.dependency "ABI50_0_0hermes-engine"
    s.dependency "ABI50_0_0React-RuntimeHermes"
    s.exclude_files = "ReactCommon/RCTJscInstance.{mm,h}"
  else
    s.dependency "ABI50_0_0React-jsc"
    s.exclude_files = "ReactCommon/RCTHermesInstance.{mm,h}"
  end
end
