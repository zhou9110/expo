# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "..", "..", "..", "..", "package.json")))
version = package['version']



folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1 -Wno-comma -Wno-shorten-64-to-32 -Wno-gnu-zero-variadic-macro-arguments'
folly_version = '2022.05.16.00'
boost_compiler_flags = '-Wno-documentation'
using_hermes = ENV['USE_HERMES'] == nil || ENV['USE_HERMES'] == "1"

header_search_paths = [
  "\"$(PODS_ROOT)/boost\"",
  "\"$(PODS_ROOT)/RCT-Folly\"",
  "\"$(PODS_ROOT)/DoubleConversion\"",
  "\"$(PODS_ROOT)/fmt/include\"",
  "\"$(PODS_ROOT)/Headers/Private/React-Core\"",
]

create_header_search_path_for_frameworks("ReactCommon-Samples").each { |search_path| header_search_paths << "\"#{search_path}\""}

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0ReactCommon-Samples"
  s.module_name            = "ABI50_0_0ReactCommon_Samples"
  s.header_dir             = "ABI50_0_0ReactCommon"
  s.version                = version
  s.summary                = "-"  # TODO
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
  s.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => header_search_paths,
                               "USE_HEADERMAP" => "YES",
                               "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
                               "GCC_WARN_PEDANTIC" => "YES" }
  if ENV['USE_FRAMEWORKS']
    s.header_mappings_dir     = './'
  end



  s.source_files = "ReactCommon/**/*.{cpp,h}",
        "platform/ios/**/*.{mm,cpp,h}"

  s.dependency "RCT-Folly"
  s.dependency "DoubleConversion"
  s.dependency "fmt", '~> 6.2.1'
  s.dependency "ABI50_0_0React-Core"
  s.dependency "ABI50_0_0React-cxxreact"
  s.dependency "ABI50_0_0React-jsi"
  add_dependency(s, "ABI50_0_0React-Codegen", :additional_framework_paths => ["build/generated/ios"])
  add_dependency(s, "ABI50_0_0ReactCommon", :subspec => "turbomodule/core", :additional_framework_paths => ["react/nativemodule/core"])
  add_dependency(s, "ABI50_0_0React-NativeModulesApple", :additional_framework_paths => ["build/generated/ios"])

  if using_hermes
    s.dependency "ABI50_0_0hermes-engine"
  else
    s.dependency "ABI50_0_0React-jsc"
  end
end
