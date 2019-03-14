import Foundation
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window!.backgroundColor = UIColor.white
    self.window!.rootViewController = RootViewController()
    self.window!.makeKeyAndVisible()
    return true
  }

}
