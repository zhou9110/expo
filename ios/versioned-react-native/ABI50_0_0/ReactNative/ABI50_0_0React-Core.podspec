# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
version = package['version']



folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -DFOLLY_CFG_NO_COROUTINES=1 -Wno-comma -Wno-shorten-64-to-32'
folly_version = '2022.05.16.00'
socket_rocket_version = '0.6.1'
boost_compiler_flags = '-Wno-documentation'

use_hermes = ENV['USE_HERMES'] == nil || ENV['USE_HERMES'] == '1'

header_subspecs = {
  'CoreModulesHeaders'          => 'React/CoreModules/**/*.h',
  'RCTActionSheetHeaders'       => 'Libraries/ActionSheetIOS/*.h',
  'RCTAnimationHeaders'         => 'Libraries/NativeAnimation/{Drivers/*,Nodes/*,*}.{h}',
  'RCTBlobHeaders'              => 'Libraries/Blob/{ABI50_0_0RCTBlobManager,ABI50_0_0RCTFileReaderModule}.h',
  'RCTImageHeaders'             => 'Libraries/Image/*.h',
  'RCTLinkingHeaders'           => 'Libraries/LinkingIOS/*.h',
  'RCTNetworkHeaders'           => 'Libraries/Network/*.h',
  'RCTPushNotificationHeaders'  => 'Libraries/PushNotificationIOS/*.h',
  'RCTSettingsHeaders'          => 'Libraries/Settings/*.h',
  'RCTTextHeaders'              => 'Libraries/Text/**/*.h',
  'RCTVibrationHeaders'         => 'Libraries/Vibration/*.h',
}

frameworks_search_paths = []
frameworks_search_paths << "\"$(PODS_CONFIGURATION_BUILD_DIR)/ABI50_0_0React-hermes\"" if use_hermes

header_search_paths = [
  "$(PODS_TARGET_SRCROOT)/ReactCommon",
  "$(PODS_ROOT)/boost",
  "$(PODS_ROOT)/DoubleConversion",
  "$(PODS_ROOT)/fmt/include",
  "$(PODS_ROOT)/RCT-Folly",
  "${PODS_ROOT}/Headers/Public/FlipperKit",
  "$(PODS_ROOT)/Headers/Public/ABI50_0_0ReactCommon",
].concat(use_hermes ? [
  "$(PODS_ROOT)/Headers/Public/ABI50_0_0React-hermes",
  "$(PODS_ROOT)/Headers/Public/ABI50_0_0hermes-engine"
] : [])

Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-Core"
  s.version                = version
  s.summary                = "The core of React Native."
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.resource_bundle        = { "RCTI18nStrings" => ["React/I18n/strings/*.lproj"]}
  s.compiler_flags         = folly_compiler_flags + ' ' + boost_compiler_flags
  s.header_dir             = "ABI50_0_0React"
  s.framework              = "JavaScriptCore"
  s.pod_target_xcconfig    = {
                               "HEADER_SEARCH_PATHS" => header_search_paths,
                               "DEFINES_MODULE" => "YES",
                               "GCC_PREPROCESSOR_DEFINITIONS" => "RCT_METRO_PORT=${RCT_METRO_PORT}",
                               "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
                               "FRAMEWORK_SEARCH_PATHS" => frameworks_search_paths.join(" ")
                             }
  s.user_target_xcconfig   = { "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/Headers/Private/ABI50_0_0React-Core\""}
  s.default_subspec        = "Default"

  s.subspec "Default" do |ss|
    ss.source_files           = "React/**/*.{c,h,m,mm,S,cpp}"
    exclude_files = [
      "React/CoreModules/**/*",
      "React/DevSupport/**/*",
      "React/Fabric/**/*",
      "React/FBReactNativeSpec/**/*",
      "React/Tests/**/*",
      "React/Inspector/**/*",
    ]
    # If we are using Hermes (the default is use hermes, so USE_HERMES can be nil), we don't have jsc installed
    # So we have to exclude the JSCExecutorFactory
    #
    # NOTE(kudo): Exposing JSC files as Expo Go hosts duo engines
    # if use_hermes
    #   exclude_files = exclude_files.append("React/CxxBridge/JSCExecutorFactory.{h,mm}")
    # end
    ss.exclude_files = exclude_files
    ss.private_header_files   = "React/Cxx*/*.h"
  end

  s.subspec "DevSupport" do |ss|
    ss.source_files = "React/DevSupport/*.{h,mm,m}",
                      "React/Inspector/*.{h,mm,m}"

    ss.dependency "ABI50_0_0React-Core/Default", version
    ss.dependency "ABI50_0_0React-Core/RCTWebSocket", version
    ss.dependency "ABI50_0_0React-jsinspector", version
  end

  s.subspec "RCTWebSocket" do |ss|
    ss.source_files = "Libraries/WebSocket/*.{h,m}"
    ss.dependency "ABI50_0_0React-Core/Default", version
  end

  # Add a subspec containing just the headers for each
  # pod that should live under <React/*.h>
  header_subspecs.each do |name, headers|
    s.subspec name do |ss|
      ss.source_files = headers
      ss.dependency "ABI50_0_0React-Core/Default"
    end
  end

  s.dependency "RCT-Folly", folly_version
  s.dependency "ABI50_0_0React-cxxreact"
  s.dependency "ABI50_0_0React-perflogger"
  s.dependency "ABI50_0_0React-jsi"
  s.dependency "ABI50_0_0React-jsiexecutor"
  s.dependency "ABI50_0_0React-utils"
  s.dependency "SocketRocket", socket_rocket_version
  s.dependency "ABI50_0_0React-runtimescheduler"
  s.dependency "ABI50_0_0Yoga"
  s.dependency "glog"

  if use_hermes
    s.dependency 'ABI50_0_0React-hermes'
    s.dependency 'ABI50_0_0hermes-engine'
  else
    s.dependency 'ABI50_0_0React-jsc'
  end
end
