import UIKit
import SVProgressHUD
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupBasicSettings()
        return true
    }
}
private extension AppDelegate{
    func setupBasicSettings(){
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
    }
}
