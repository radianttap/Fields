//
//  AppDelegate.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var applicationCoordinator: ApplicationCoordinator!

	func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)

		setupLogger()
		setupAnalytics()

		applicationCoordinator = {
			let c = ApplicationCoordinator(application: application)
			return c
		}()
		window?.rootViewController = applicationCoordinator.rootViewController

		return true
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window?.makeKeyAndVisible()
		applicationCoordinator.start()

		return true
	}
}

extension AppDelegate: Loggable {}

private extension AppDelegate {
	func setupLogger() {
		let stub = LoggerStub()
		stub.minimumLevel = .debug

		Logger.sharedLogger.setupLogger(logger: stub)
	}

	func setupAnalytics() {
	}
}
