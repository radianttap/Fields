//
//  NeedsDependency.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/14/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

//	Protocol you need to apply to all the Coordinators,
//	so the new `appDependency` value is propagated down.

protocol NeedsDependency: class {
	var appDependency: AppDependency? { get set }
}

extension NeedsDependency where Self: Coordinating {
	func updateChildCoordinatorDependencies() {
		self.childCoordinators.forEach { (_, coordinator) in
			if let c = coordinator as? NeedsDependency {
				c.appDependency = appDependency
			}
		}
	}
}


