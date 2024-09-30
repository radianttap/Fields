//
//  AppDelegate.swift
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)

		let vc = prepareLogin()

		//	UIKit setup
		let nc = UINavigationController(rootViewController: vc)
		window?.rootViewController = nc

		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window?.makeKeyAndVisible()
		return true
	}
}

private extension AppDelegate {
	func prepareLogin() -> LoginController {
		let vc = LoginController()

		//	Model (data source)
		let user = User()
		let ds = LoginDataSource(user)
		vc.dataSource = ds
		
		return vc
	}
}
