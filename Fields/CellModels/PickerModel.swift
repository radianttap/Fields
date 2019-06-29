//
//  PickerModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to PickerCell instance.
///
///	Note: Adjust everything here in any way you need.
class PickerModel<T>: FieldModel {
	///	unique identifier (across the containing form) for this field
	let id: String

	///	String to display in the title label
	var title: String?

	///	Pre-selected value
	var value: T?

	var values: [T] = []

	var valueFormatter: (T?) -> String?

	///	Custom configuration for the picker field
	///
	///	Default implementation does nothing.
	var customSetup: () -> Void = {}

	///	Method called every time a value is picked
	///
	///	Default implementation does nothing.
	var valueChanged: (T?) -> Void = {_ in}

	init(id: String,
		 title: String? = nil,
		 value: T? = nil,
		 values: [T] = [],
		 valueFormatter: @escaping (T?) -> String?,
		 customSetup: @escaping () -> Void = {},
		 valueChanged: @escaping (T?) -> Void = {_ in}
		){
		self.id = id

		self.title = title
		self.value = value
		self.values = values

		self.valueFormatter = valueFormatter

		self.customSetup = customSetup
		self.valueChanged = valueChanged
	}
}

