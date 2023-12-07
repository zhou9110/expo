# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "..", "package.json")))
version = package['version']



folly_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1'
folly_compiler_flags = folly_flags + ' ' + '-Wno-comma -Wno-shorten-64-to-32'
folly_version = '2022.05.16.00'
boost_compiler_flags = '-Wno-documentation'

header_search_paths = [
  "\"$(PODS_TARGET_SRCROOT)/ReactCommon\"",
  "\"$(PODS_ROOT)/boost\"",
  "\"$(PODS_ROOT)/DoubleConversion\"",
  "\"$(PODS_ROOT)/fmt/include\"",
  "\"$(PODS_ROOT)/RCT-Folly\"",
  "\"$(PODS_ROOT)/Headers/Private/ABI50_0_0React-Core\"",
  "\"$(PODS_ROOT)/Headers/Private/ABI50_0_0Yoga\"",
  "\"$(PODS_ROOT)/Headers/Public/React-Codegen\"",
]

if ENV['USE_FRAMEWORKS']
  create_header_search_path_for_frameworks("React-RCTFabric", :framework_name => "RCTFabric")
    .each { |search_path| header_search_paths << "\"#{search_path}\""}
end

module_name = "ABI50_0_0RCTFabric"
header_dir = "ABI50_0_0React"

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-RCTFabric"
  s.version                = version
  s.summary                = "RCTFabric for React Native."
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.source_files           = "Fabric/**/*.{c,h,m,mm,S,cpp}"
  s.exclude_files          = "**/tests/*",
                             "**/android/*",
  s.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
  s.header_dir             = header_dir
  s.module_name            = module_name
  s.framework              = ["JavaScriptCore", "MobileCoreServices"]
  s.pod_target_xcconfig    = {
    "HEADER_SEARCH_PATHS" => header_search_paths,
    "OTHER_CFLAGS" => "$(inherited) -DRN_FABRIC_ENABLED" + " " + folly_flags,
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++20"
  }.merge!(ENV['USE_FRAMEWORKS'] != nil ? {
    "PUBLIC_HEADERS_FOLDER_PATH" => "#{module_name}.framework/Headers/#{header_dir}"
  }: {})

  s.dependency "ABI50_0_0React-Core"
  s.dependency "ABI50_0_0React-RCTImage"
  s.dependency "RCT-Folly/Fabric", folly_version
  s.dependency "glog"
  s.dependency "ABI50_0_0Yoga"
  s.dependency "ABI50_0_0React-RCTText"
  s.dependency "ABI50_0_0React-jsi"

  add_dependency(s, "ABI50_0_0React-FabricImage")
  add_dependency(s, "ABI50_0_0React-Fabric", :additional_framework_paths => [
    "react/renderer/textlayoutmanager/platform/ios",
    "react/renderer/components/textinput/iostextinput",
    "react/renderer/components/view/platform/cxx",
    "react/renderer/imagemanager/platform/ios",
  ])
  add_dependency(s, "ABI50_0_0React-nativeconfig")
  add_dependency(s, "ABI50_0_0React-graphics", :additional_framework_paths => ["react/renderer/graphics/platform/ios"])
  add_dependency(s, "ABI50_0_0React-ImageManager")
  add_dependency(s, "ABI50_0_0React-debug")
  add_dependency(s, "ABI50_0_0React-utils")
  add_dependency(s, "ABI50_0_0React-rendererdebug")
  add_dependency(s, "ABI50_0_0React-runtimescheduler")

  if ENV["USE_HERMES"] == nil || ENV["USE_HERMES"] == "1"
    s.dependency "ABI50_0_0hermes-engine"
  else
    s.dependency "ABI50_0_0React-jsc"
  end

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = "Tests/**/*.{mm}"
    test_spec.framework = "XCTest"
  end
end
