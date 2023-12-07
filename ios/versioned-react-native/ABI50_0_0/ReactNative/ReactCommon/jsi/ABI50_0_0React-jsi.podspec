# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

js_engine = ENV['USE_HERMES'] == "0" ?
  :jsc :
  :hermes

package = JSON.parse(File.read(File.join(__dir__, "..", "..", "package.json")))
version = package['version']



folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2022.05.16.00'
boost_compiler_flags = '-Wno-documentation'

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-jsi"
  s.version                = version
  s.summary                = "JavaScript Interface layer for React Native"
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }

  s.header_dir    = "ABI50_0_0jsi"
  s.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
  s.pod_target_xcconfig    = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\" \"$(PODS_ROOT)/RCT-Folly\" \"$(PODS_ROOT)/DoubleConversion\" \"$(PODS_ROOT)/fmt/include\"",
                               "DEFINES_MODULE" => "YES" }

  s.dependency "boost", "1.83.0"
  s.dependency "DoubleConversion"
  s.dependency 'fmt' , '~> 6.2.1'
  s.dependency "RCT-Folly", folly_version
  s.dependency "glog"

  s.source_files  = "**/*.{cpp,h}"
  files_to_exclude = [
                      "jsi/jsilib-posix.cpp",
                      "jsi/jsilib-windows.cpp",
                      "**/test/*"
                     ]
  if js_engine == :hermes
    # JSI is a part of hermes-engine. Including them also in react-native will violate the One Definition Rulle.
    files_to_exclude += [ "jsi/jsi.cpp" ]
    s.dependency "ABI50_0_0hermes-engine"
  end
  s.exclude_files = files_to_exclude
end
