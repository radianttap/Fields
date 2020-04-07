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

	var fieldsCollectionController: FieldsCollectionController? {
		if let c = self as? FieldsCollectionController {
			return c
		}

		if let c = next as? FieldsCollectionController {
			return c
		}

		return next?.fieldsCollectionController
	}

	func containingCell<T>() -> T? {
		if let c = self as? T {
			return c
		}

		if let c = next as? T {
			return c
		}

		return next?.containingCell()
	}
}
