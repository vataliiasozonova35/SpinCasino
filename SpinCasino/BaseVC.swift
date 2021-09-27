
import UIKit

class BaseVC: UIViewController {
    
   
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}

class BaseNC: UINavigationController {
 
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }
}
