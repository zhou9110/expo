# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.


# Set up Bridgeless dependencies
#
# @parameter react_native_path: relative path to react-native
def setup_bridgeless!(react_native_path: "../node_modules/react-native", use_hermes: true)
    pod 'ABI50_0_0React-jsitracing', :path => "#{react_native_path}/ReactCommon/hermes/executor/", :project_name => 'ABI50_0_0'
    pod 'ABI50_0_0React-runtimescheduler', :path => "#{react_native_path}/ReactCommon/react/renderer/runtimescheduler", :project_name => 'ABI50_0_0'
    pod 'ABI50_0_0React-RuntimeCore', :path => "#{react_native_path}/ReactCommon/react/runtime", :project_name => 'ABI50_0_0'
    pod 'ABI50_0_0React-RuntimeApple', :path => "#{react_native_path}/ReactCommon/react/runtime/platform/ios", :project_name => 'ABI50_0_0'
    if use_hermes
        pod 'ABI50_0_0React-RuntimeHermes', :path => "#{react_native_path}/ReactCommon/react/runtime", :project_name => 'ABI50_0_0'
    end
end
