//
//  ToggleModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to ToggleCell instance.
class ToggleModel: FieldModel, @unchecked Sendable {
	///	String to next to the `UISwitch`
	var title: String

	///	Value for the `UISwitch`
	var value: Bool

	///	Custom configuration for the `UISwitch`.
	///
	///	Default implementation does nothing.
	var customSetup: (UISwitch) -> Void = {_ in}

	///	Method called every time UISwitch is toggled.
	///
	///	Default implementation does nothing.
	var valueChanged: (Bool, FormFieldCell) -> Void = {_, _ in}

	init(id: String,
		 title: String,
		 value: Bool,
		 customSetup: @escaping (UISwitch) -> Void = {_ in},
		 valueChanged: @escaping (Bool, FormFieldCell) -> Void = {_, _ in}
	){
		self.title = title
		self.value = value
		super.init(id: id)

		self.customSetup = customSetup
		self.valueChanged = valueChanged
	}
}

