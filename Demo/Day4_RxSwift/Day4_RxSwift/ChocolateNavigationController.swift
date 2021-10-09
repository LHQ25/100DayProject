
import UIKit

/// Subclass to make status bar style work for views embedded in this navigation controller.
class ChocolateNavigationController: UINavigationController {
    
    //子控制器的状态栏和导航条一致
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
