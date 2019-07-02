//
//  TextFieldModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to TextFieldCell instance.
class TextFieldModel: FieldModel {
	///	unique identifier (across the containing form) for this field
	let id: String

	///	String to display in the title label
	var title: String?

	///	Value to show inside the textField
	var value: String?

	///	Placeholder value to show inside the textField
	var placeholder: String?

	///	Custom configuration for the textField.
	///
	///	Default implementation does nothing.
	var customSetup: (UITextField) -> Void = {_ in}

	///	Method called every time value inside the field changes.
	///
	///	Default implementation does nothing.
	var valueChanged: (String?, TextFieldCell) -> Void = {_, _ in}

	init(id: String,
		 title: String? = nil,
		 value: String? = nil,
		 placeholder: String? = nil,
		 customSetup: @escaping (UITextField) -> Void = {_ in},
		 valueChanged: @escaping (String?, TextFieldCell) -> Void = {_, _ in}
	){
		self.id = id

		self.title = title
		self.value = value
		self.placeholder = placeholder

		self.customSetup = customSetup
		self.valueChanged = valueChanged
	}
}

