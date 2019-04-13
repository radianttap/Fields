//
//  AppDependency.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

struct AppDependency {
	var annanowService: Annanow?
	var dataManager: DataManager?
	var accountManager: AccountManager?

	//	Init

	init(annanowService: Annanow? = nil,
		 dataManager: DataManager? = nil,
		 accountManager: AccountManager? = nil)
	{
		self.annanowService = annanowService
		self.dataManager = dataManager
		self.accountManager = accountManager
	}
}

