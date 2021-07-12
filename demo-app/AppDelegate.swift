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
//		let vc = prepareSlideTest()

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

//	func prepareSlideTest() -> SlideTestController {
//		let layout = FieldHeightSizingLayout()
//		layout.minimumLineSpacing = 8
//		layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//		let vc = SlideTestController(layout: layout)
//
//		//	Model (data source)
//		let ds = SlideTestDataSource()
//		vc.dataSource = ds
//
//		return vc
//	}
}
