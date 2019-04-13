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
	}
}

extension DataManager {

}
