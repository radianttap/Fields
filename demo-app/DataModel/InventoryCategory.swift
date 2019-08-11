//
//  InventoryCategory.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 8/11/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation

struct InventoryCategory: Hashable {
	enum ID: String {
		case watch
		case dress
		case handbag
		case makeup
		case underwear
	}

	let id: ID

	init(id: ID) {
		self.id = id
	}
}
