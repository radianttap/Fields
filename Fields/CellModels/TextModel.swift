//
//  TextModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to TextCell instance.
class TextModel: FieldModel {
	///	unique identifier (across the containing form) for this field
	let id: String

	///	Title text, explaining what the `value` is
	var title: String

	///	Text that represent the shown value
	var value: String

	///	Custom configuration for the `UILabel` showing the `value` string.
	///
	///	Default implementation does nothing.
	var customSetup: (UILabel) -> Void = {_ in}

	init(id: String,
		 title: String,
		 value: String,
		 customSetup: @escaping (UILabel) -> Void = {_ in}
	){
		self.id = id

		self.title = title
		self.value = value

		self.customSetup = customSetup
	}
}

