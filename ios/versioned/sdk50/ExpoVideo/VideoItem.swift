// Copyright 2023-present 650 Industries. All rights reserved.

import ABI50_0_0ExpoModulesCore

internal final class VideoItem: SharedObject {
  let playerItem: AVPlayerItem

  init(url: URL) {
    playerItem = AVPlayerItem(url: url)
  }
}
