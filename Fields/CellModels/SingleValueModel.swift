//
//  SingleValueModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model where you pick a particular `value` (out of set of possible values) by selecting the corresponding cell.
///
///	Each model/cell is mutually exclusive, thus this is most likely to be part of one section.
class SingleValueModel<T: Hashable>: FieldModel, @unchecked Sendable {
	///	String to display in the title label
	var title: String?

	///	Assigned value of type `T`
	var value: T

	var isChosen = false

	///	Method that should be called when `FieldCell` using this model's instance is selected.
	///
	///	Default implementation does nothing.
	var valueSelected: (T, FormFieldCell) -> Void = {_, _ in}

	init(id: String,
		 title: String? = nil,
		 value: T,
		 isChosen: Bool = false,
		 valueSelected: @escaping (T, FormFieldCell) -> Void = {_, _ in}
	){
		self.isChosen = isChosen
		self.title = title
		self.value = value
		super.init(id: id)

		self.valueSelected = valueSelected
	}
}

