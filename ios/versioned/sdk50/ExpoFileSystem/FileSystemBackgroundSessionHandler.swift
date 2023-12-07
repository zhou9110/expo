// Copyright 2023-present 650 Industries. All rights reserved.

import ABI50_0_0ExpoModulesCore

public final class FileSystemBackgroundSessionHandler: ExpoAppDelegateSubscriber, ABI50_0_0EXSessionHandlerProtocol {
  public typealias BackgroundSessionCompletionHandler = () -> Void

  private var completionHandlers: [String: BackgroundSessionCompletionHandler] = [:]

  public func invokeCompletionHandler(forSessionIdentifier identifier: String) {
    guard let completionHandler = completionHandlers[identifier] else {
      return
    }
    DispatchQueue.main.async {
      completionHandler()
    }
    completionHandlers.removeValue(forKey: identifier)
  }

  // MARK: - ExpoAppDelegateSubscriber

  public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    completionHandlers[identifier] = completionHandler
  }
}
