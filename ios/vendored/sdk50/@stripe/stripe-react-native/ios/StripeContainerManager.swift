import Foundation

@objc(ABI50_0_0StripeContainerManager)
class StripeContainerManager: ABI50_0_0RCTViewManager {
    override func view() -> UIView! {
        return StripeContainerView()
    }
        
    override class func requiresMainQueueSetup() -> Bool {
        return false
    }
}
