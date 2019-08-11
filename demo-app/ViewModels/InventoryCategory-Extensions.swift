//
//  InventoryCategory-Extensions.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 8/11/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

extension InventoryCategory {
	var icon: UIImage {
		switch id {
		case .watch:
			return UIImage(imageLiteralResourceName: "icon-watch")
		case .dress:
			return UIImage(imageLiteralResourceName: "icon-dress")
		case .handbag:
			return UIImage(imageLiteralResourceName: "icon-handbag")
		case .makeup:
			return UIImage(imageLiteralResourceName: "icon-makeup")
		case .underwear:
			return UIImage(imageLiteralResourceName: "icon-underwear")
		}
	}
}

