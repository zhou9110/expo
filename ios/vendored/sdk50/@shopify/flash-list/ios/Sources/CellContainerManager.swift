import Foundation

@objc(ABI50_0_0CellContainerManager)
class CellContainerManager: ABI50_0_0RCTViewManager {  
    override func view() -> UIView! {
        return CellContainer()
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}
