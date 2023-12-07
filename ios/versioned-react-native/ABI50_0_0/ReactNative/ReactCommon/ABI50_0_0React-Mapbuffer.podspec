# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

require "json"

package = JSON.parse(File.read(File.join(__dir__, "..", "package.json")))
version = package['version']



Pod::Spec.new do |s|
  s.name                   = "ABI50_0_0React-Mapbuffer"
  s.version                = version
  s.summary                = "-"
  s.homepage               = "https://reactnative.dev/"
  s.license                = package["license"]
  s.author                 = "Meta Platforms, Inc. and its affiliates"
  s.platforms              = min_supported_versions
  s.source                 = { :path => "." }
  s.source_files           = "react/renderer/mapbuffer/*.{cpp,h}"
  s.exclude_files          = "react/renderer/mapbuffer/tests"
  s.public_header_files    = 'react/renderer/mapbuffer/*.h'
  s.header_dir             = "ABI50_0_0react/renderer/mapbuffer"
  s.pod_target_xcconfig = {  "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)\"", "USE_HEADERMAP" => "YES",
                            "CLANG_CXX_LANGUAGE_STANDARD" => "c++20" }

  if ENV['USE_FRAMEWORKS']
    s.header_mappings_dir     = './'
    s.module_name             = 'ABI50_0_0React_Mapbuffer'
  end

  s.dependency "glog"
  add_dependency(s, "ABI50_0_0React-debug")

end
