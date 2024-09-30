//
//  DatePickerModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to DatePickerCell instance.
class DatePickerModel: FieldModel, @unchecked Sendable {
	///	String to display in the title label
	var title: String?

	///	Chosen date
	var value: Date?

	///	Timestamp to show if `value` is not set
	var placeholder: Date

	///	Instance of DateFormatter to use and build String representation
	var formatter: DateFormatter

	///	Custom configuration for the date picker.
	///
	///	Default implementation does nothing.
	var customSetup: (UIDatePicker, FormFieldCell) -> Void = {_, _ in}

	///	Method called every time value of the picker changes.
	///
	///	Default implementation does nothing.
	var valueChanged: (Date?, FormFieldCell) -> Void = {_, _ in}

	init(id: String,
		 title: String? = nil,
		 value: Date? = nil,
		 placeholder: Date = Date(),
		 formatter: DateFormatter,
		 customSetup: @escaping (UIDatePicker, FormFieldCell) -> Void = {_, _ in},
		 valueChanged: @escaping (Date?, FormFieldCell) -> Void = {_, _ in}
	){
		self.title = title
		self.value = value
		self.placeholder = placeholder
		self.formatter = formatter
		super.init(id: id)

		self.customSetup = customSetup
		self.valueChanged = valueChanged
	}
}

