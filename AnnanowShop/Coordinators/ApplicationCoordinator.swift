//
//  ApplicationCoordinator.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import UIKit

/**
	Top-level App/UI Coordinator. Strongly referenced by appDelegate and thus it's never stopped.

	Directly connected to AppDelegate and routes all the stuff iOS sends through AppDelegate and Application objects.
	It instantiates and configures child Coordinators that should be shown to the customer.

	NOTE: currently using UINavigationController as main container in the app.
	Replaced with UITabBarController or whatever is needed by app's design.
*/
final class ApplicationCoordinator: NavigationCoordinator {
	private weak var application: UIApplication!

	init(application: UIApplication, rootViewController: UINavigationController? = nil) {
		self.application = application
		super.init(rootViewController: rootViewController ?? UINavigationController())

		log(level: .all, "Init")
	}


	//	MARK:- Middleware
	//	All the shared instances are kept here, since this Coordinator is the only one that is always in memory.
	private lazy var annanowService: Annanow = Annanow()
	private lazy var dataManager: DataManager = DataManager(annanowService: annanowService)
	private lazy var accountManager: AccountManager = AccountManager(dataManager: dataManager)
	//	Rebuild this value anytime a new service/data/middleware entity is instantiated.
	var appDependency: AppDependency?



	//	MARK:- Content
	/**
		Declaration of all possible UI "modules" in the app, each represented by one custom Coordinator instance.
	*/
	enum Section {
		case splash
	}
	var section: Section = .splash




	//	MARK:- Coordinator Lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		log(level: .all, "↘︎")

		buildDependencies()
		super.start(with: completion)

		// The moment when app logic decides what is the first content VC to show
		setupContent()

		log(level: .all, "↗︎")
	}

}

extension ApplicationCoordinator: Loggable {}

private extension ApplicationCoordinator {
	///	(re)build `appDependency` value as many times as you need
	func buildDependencies() {
		appDependency = AppDependency(annanowService: annanowService,
									  dataManager: dataManager,
									  accountManager: accountManager)
		log(level: .verbose, "AppDependency re-built.")
	}

	///	Sets up actual content to show, inside rootViewController
	func setupContent() {
		log(level: .all, "")

		switch section {
		case .splash:
			let vc = UIViewController()
			root(vc)
			log(level: .info, "root: Splash screen")
		}
	}
}
