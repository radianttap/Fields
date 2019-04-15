//
//  AccountManager.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

/**
	Middleware entity, handles all stuff related to logged-in User.

	Login, Register, Account verification etc – all of them must use this module.

	This module communicates with UI, thus its methods must observe the queue results should be returned to.
	Usually, the callee would send a queue instance it expects the result to be returned. 
*/
final class AccountManager: NSObject {
	private var dataManager: DataManager

	//	Init

	init(dataManager: DataManager) {
		self.dataManager = dataManager

		super.init()
		log(level: .all, "Init")
	}

	//	Public

	private(set) var user: User?
}

extension AccountManager: Loggable {}

extension AccountManager {
	var isLoggedIn: Bool {
		return user != nil
	}

	func login(username: String, password: String, onQueue queue: OperationQueue? = nil, callback: @escaping (UserResult) -> Void) {
		dataManager.login(username: username, password: password) {
			dataResult in

			switch dataResult {
			case .success(let user):
				self.user = user

				OperationQueue.perform( callback(.success(user)), onQueue: queue)

			case .failure(let dataError):
				OperationQueue.perform( callback(.failure(AccountError.dataError(dataError))), onQueue: queue)
			}
		}
	}
}
