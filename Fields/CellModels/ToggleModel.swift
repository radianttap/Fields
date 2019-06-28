//
//  ToggleModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to ToggleCell instance.
///
///	Note: Adjust everything here in any way you need.
class ToggleModel: FieldModel {
	///	unique identifier (across the containing form) for this field
	let id: String

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
	var valueChanged: (Bool) -> Void = {_ in}

	init(id: String,
		 title: String,
		 value: Bool,
		 customSetup: @escaping (UISwitch) -> Void = {_ in},
		 valueChanged: @escaping (Bool) -> Void = {_ in}
		){
		self.id = id

		self.title = title
		self.value = value

		self.customSetup = customSetup
		self.valueChanged = valueChanged
	}
}

