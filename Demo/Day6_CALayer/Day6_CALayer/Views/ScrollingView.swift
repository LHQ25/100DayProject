
import UIKit
import QuartzCore

class ScrollingView: UIView {
    override class var layerClass: AnyClass {
        return CAScrollLayer.self
    }
}
