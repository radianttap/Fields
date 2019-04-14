//
//  AccountCoordinator.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/14/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import UIKit

final class AccountCoordinator: NavigationCoordinator {
	var appDependency: AppDependency?


	enum Page: AutoBoxable {
		case login
		case forgotPassword
	}
	private(set) var page: Page = .login




	//	MARK:- Coordinator Lifecycle

	override func start(with completion: @escaping () -> Void = {}) {
		super.start(with: completion)

		displayContent()
	}

	override func handlePopBack(to vc: UIViewController?) {
		guard let vc = vc else { return }
		recognizePage(for: vc)
	}

	//	MARK:- coordinatingResponder
}




extension AccountCoordinator {
	func display(page: Page, sender: Any? = nil) {
		self.page = page
	}
}





//	MARK:- Private

private extension AccountCoordinator {
	func displayContent(for sender: Any? = nil) {
		switch page {
		case .login:
			let vc = LoginController.instantiate()
			root(vc)

		case .forgotPassword:
			fatalError("Not implemented yet.")
		}
	}

	func recognizePage(for vc: UIViewController) {
		switch vc {
		case is LoginController:
			page = .login

//		case let vc as ForgotPasswordController:
//			page = .forgotPassword

		default:
			break
		}
	}
}