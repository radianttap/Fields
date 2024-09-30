//
//  FormTextModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to TextCell instance.
class FormTextModel: FieldModel, @unchecked Sendable {
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
		self.title = title
		self.value = value
		super.init(id: id)

		self.customSetup = customSetup
	}
}

