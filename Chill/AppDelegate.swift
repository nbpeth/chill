
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController:ViewController?


    private func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        return true
    }

    private func applicationWillResignActive(application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        viewController = self.window?.rootViewController as? ViewController
        viewController?.checkState()

    }

    private func applicationWillTerminate(application: UIApplication) {
  
    }



}

