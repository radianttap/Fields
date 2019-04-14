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
final class ApplicationCoordinator: NavigationCoordinator, NeedsDependency {
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
	var appDependency: AppDependency? {
		didSet {
			updateChildCoordinatorDependencies()
			processQueuedMessages()
		}
	}



	//	MARK:- Content
	/**
		Declaration of all possible UI "modules" in the app, each represented by one custom Coordinator instance.
	*/
	enum Section {
		case splash
		case account(page: AccountCoordinator.Page?)
	}
	var section: Section = .splash




	//	MARK:- Coordinator Lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		log(level: .all, "↘︎")

		buildDependencies()
		super.start(with: completion)

		setupContent()

		log(level: .all, "↗︎")
	}

}

extension ApplicationCoordinator: Loggable {}

private extension ApplicationCoordinator {
	///	(re)builds `appDependency` value
	func buildDependencies() {
		appDependency = AppDependency(annanowService: annanowService,
									  dataManager: dataManager,
									  accountManager: accountManager)
		log(level: .verbose, "AppDependency re-built.")
	}

	///	Implements initial logic deciding what should be the first UI content to display, when app starts.
	func setupContent() {
		if !accountManager.isLoggedIn {
			log(level: .debug, "User not found, will display login")
			section = .account(page: .login)

			displayContent()
			return
		}

		displayContent()
	}

	///	Sets up actual content to show, inside rootViewController
	func displayContent(sender: Any? = nil) {
		log(level: .all, "")

		switch section {
		case .splash:
			let vc = UIViewController()
			root(vc)
			log(level: .info, "root: Splash screen")

		case .account(let page):
			displayAccount(page: page, sender: sender)

			if let page = page {
				log(level: .info, "root: Account, page=\( page )")
			} else {
				log(level: .info, "root: Account, page=(default)")
			}
		}
	}
}


private extension ApplicationCoordinator {
	func displayAccount(page: AccountCoordinator.Page? = nil, sender: Any? = nil) {
		let identifier = String(describing: AccountCoordinator.self)

		if let c = childCoordinators[identifier] as? AccountCoordinator {
			c.appDependency = appDependency
			if let page = page {
				c.display(page: page, sender: sender)
			}
			c.activate()
			return
		}

		let c = AccountCoordinator(rootViewController: rootViewController)
		c.appDependency = appDependency
		if let page = page {
			c.display(page: page, sender: sender)
		}
		startChild(coordinator: c)
	}
}
