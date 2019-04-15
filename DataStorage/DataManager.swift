//
//  DataManager.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

/**
	DataManager receives requests for Model instances from Middleware,
	retrieves them from its local storage and/or services it communicates with.

	DataManager knows nothing about UI, does not care about main thread or any thread in general.
	Its methods should be callable on any queue/thread, main or background.

	Guideline: create one and just one internal method for each atomic data operation.
*/
final class DataManager {
	private var annanowService: Annanow

	init(annanowService: Annanow) {
		self.annanowService = annanowService

		log(level: .all, "Init")
	}
}

extension DataManager: Loggable {}

extension DataManager {
	func login(username: String, password: String, callback: @escaping ( Result<User, DataError> ) -> Void) {
		let endpoint = AnnanowEndpoint.login(username: username, password: password)

		annanowService.call(endpoint) {
			jsonResult in

			switch jsonResult {
			case .success(let JSON):
				//	convert from JSON to User here
				let user = User()
				callback( .success(user) )

			case .failure(let annanowError):
				callback( .failure( DataError.annanowError(annanowError) ) )
			}
		}
	}

}
