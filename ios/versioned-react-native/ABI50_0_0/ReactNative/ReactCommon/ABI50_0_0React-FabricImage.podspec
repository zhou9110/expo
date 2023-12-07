# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "..", "package.json")))
version = package['version']



folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1 -Wno-comma -Wno-shorten-64-to-32 -Wno-gnu-zero-variadic-macro-arguments'
folly_version = '2022.05.16.00'
folly_dep_name = 'RCT-Folly/Fabric'
boost_compiler_flags = '-Wno-documentation'
react_native_path = ".."

header_search_path = [
  "\"$(PODS_ROOT)/boost\"",
  "\"$(PODS_TARGET_SRCROOT)/ReactCommon\"",
  "\"$(PODS_ROOT)/RCT-Folly\"",
  "\"$(PODS_ROOT)/Headers/Private/ABI50_0_0Yoga\"",
  "\"$(PODS_ROOT)/DoubleConversion\"",
  "\"$(PODS_ROOT)/fmt/include\"",
]

if ENV['USE_FRAMEWORKS']
  header_search_path = header_search_path + [
    "\"$(PODS_TARGET_SRCROOT)\"",
    "\"$(PODS_TARGET_SRCROOT)/react/renderer/textlayoutmanager/platform/ios\"",
    "\"$(PODS_TARGET_SRCROOT)/react/renderer/components/textinput/iostextinput\"",
    # "\"$(PODS_CONFIGURATION_BUILD_DIR)/React-Codegen/React_Codegen.framework/Headers\"",
  ]
end

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-FabricImage"
  s.version                = version
  s.summary                = "Image Component for Fabric for React Native."
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.source_files         = "react/renderer/components/image/**/*.{m,mm,cpp,h}"
  s.exclude_files        = "react/renderer/components/image/tests"
  s.header_dir           = "ABI50_0_0react/renderer/components/image"
  s.compiler_flags       = folly_compiler_flags
  s.pod_target_xcconfig = { "USE_HEADERMAP" => "YES",
                            "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
                            "HEADER_SEARCH_PATHS" => header_search_path.join(" ")
                          }

  if ENV['USE_FRAMEWORKS']
    s.header_mappings_dir     = './'
    s.module_name             = 'ABI50_0_0React_FabricImage'
  end

  s.dependency folly_dep_name, folly_version

  s.dependency "ABI50_0_0React-jsiexecutor", version
  s.dependency "ABI50_0_0RCTRequired", version
  s.dependency "ABI50_0_0RCTTypeSafety", version
  s.dependency "ABI50_0_0React-jsi"
  s.dependency "ABI50_0_0React-logger"
  s.dependency "glog"
  s.dependency "DoubleConversion"
  s.dependency 'fmt' , '~> 6.2.1'
  s.dependency "ABI50_0_0React-ImageManager"
  s.dependency "ABI50_0_0React-utils"
  s.dependency "ABI50_0_0Yoga"

  add_dependency(s, "ABI50_0_0ReactCommon", :subspec => "turbomodule/core")
  add_dependency(s, "ABI50_0_0React-graphics", :additional_framework_paths => ["react/renderer/graphics/platform/ios"])
  add_dependency(s, "ABI50_0_0React-Fabric", :additional_framework_paths => [
    "react/renderer/components/view/platform/cxx",
    "react/renderer/imagemanager/platform/ios"
  ])
  add_dependency(s, "ABI50_0_0React-rendererdebug")

  if ENV["USE_HERMES"] == nil || ENV["USE_HERMES"] == "1"
    s.dependency "ABI50_0_0hermes-engine"
  else
    s.dependency "ABI50_0_0React-jsc"
  end
end
