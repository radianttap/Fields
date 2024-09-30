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
///
class PickerModel<T: Hashable>: FieldModel, @unchecked Sendable {
	///	String to display in the title label
	var title: String?

    ///    String to display when there is no value
    var placeholder: String?

	///	Pre-selected value of type `T`
	var value: T?

	///	List of allowed values of type `T`, to choose from.
	var values: [T] = []

	///	Transforms value of `T` into String, so it can be shown inside the field and also in expanded options list cells.
	var valueFormatter: (T?) -> String?

	var isPickerShown = false

	///	Executted when PickerCell is tapped. It should display the `values` list.
	var displayPicker: (FormFieldCell) -> Void = {_ in}

	///	Method called every time a value is picked.
	///
	///	Last parameter should be `true` when using the picker in pushed VC, otherwise `false` to not do `popViewController` on selection.
	///
	///	Default implementation does nothing.
	var selectedValueAtIndex: (Int?, FormFieldCell, Bool) -> Void = {_, _, _ in}

	init(id: String,
		 title: String? = nil,
         placeholder: String? = nil,
		 value: T? = nil,
		 values: [T] = [],
		 valueFormatter: @escaping (T?) -> String?,
		 displayPicker: @escaping (FormFieldCell) -> Void = {_ in},
		 selectedValueAtIndex: @escaping (Int?, FormFieldCell, Bool) -> Void = {_, _, _ in}
	){
		self.title = title
        self.placeholder = placeholder
		self.value = value
		self.values = values
		self.valueFormatter = valueFormatter
		super.init(id: id)

		self.displayPicker = displayPicker
		self.selectedValueAtIndex = selectedValueAtIndex
	}
}

