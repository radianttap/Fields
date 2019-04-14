//
//  Account-CoordinatingResponder.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/14/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import UIKit

extension UIResponder {
	//	MARK: Navigation
	//	(could probably use just one method for this)
	//	These methods switch UI screens, so default queue is `.main`

	@objc func accountDisplayLogin(onQueue queue: OperationQueue? = .main, sender: Any? = nil) {
		coordinatingResponder?.accountDisplayLogin(onQueue: queue, sender: sender)
	}

	@objc func accountDisplayForgotPassword(onQueue queue: OperationQueue? = .main, sender: Any? = nil) {
		coordinatingResponder?.accountDisplayForgotPassword(onQueue: queue, sender: sender)
	}


	//	MARK: Actions

	///	Data path to send user/pass from Login UI and receive the Result back through callback.
	@objc func accountPerformLogin(username: String,
								   password: String,
								   onQueue queue: OperationQueue? = nil,
								   sender: Any? = nil,
								   callback: @escaping (UserResultBox) -> Void)
	{
		coordinatingResponder?.accountPerformLogin(username: username, password: password, onQueue: queue, sender: sender, callback: callback)
	}
}
