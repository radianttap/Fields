//
//  UIResponder-FieldsDelegate.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

extension UIResponder {
	var fieldsController: FieldsController? {
		if let c = self as? FieldsController {
			return c
		}

		if let c = next as? FieldsController {
			return c
		}

		return next?.fieldsController
	}
}
