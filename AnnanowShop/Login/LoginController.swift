//
//  LoginController.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/14/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import UIKit

final class LoginController: UIViewController, StoryboardLoadable {

	//	INPUT
	var userResult: UserResult? {
		didSet {
			if !isViewLoaded { return }
			process(userResult)
		}
	}
}

extension LoginController {
	override func viewDidLoad() {
		super.viewDidLoad()

		process(userResult)
	}
}

private extension LoginController {
	@IBAction func openForgotPassword(_ sender: UIButton) {
		//	OUTPUT
		accountDisplayForgotPassword(sender: self)
	}

	func process(_ userResult: UserResult?) {
		guard let userResult = userResult else {
			return
		}

		switch userResult {
		case .success(let user):
			print(user)

		case .failure(let accountError):
			print(accountError)
		}
	}

	func submit() {
		//	validate input
		let user: String = ""
		let pass: String = ""

		//	OUTPUT
		accountPerformLogin(username: user, password: pass, onQueue: .main, sender: self) {
			[weak self] boxedUserResult in
			self?.process(boxedUserResult.unbox)
		}
	}
}
