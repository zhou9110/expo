import Foundation

@objc(ABI50_0_0AutoLayoutViewManager)
class AutoLayoutViewManager: ABI50_0_0RCTViewManager {
    override func view() -> UIView! {
        return AutoLayoutView()
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
