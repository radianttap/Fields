//
//  TextViewModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to TextViewCell instance.
class TextViewModel: FieldModel, @unchecked Sendable {
	///	Minimal size of the text-view
	var minimalHeight: CGFloat

	///	String to display in the title label
	var title: String?

	///	Value to show inside the textField
	var value: String?

	///	Custom configuration for the textView.
	///
	///	Default implementation does nothing.
	var customSetup: (UITextView) -> Void = {_ in}

	///	Method called every time value inside the field changes.
	///
	///	Default implementation does nothing.
	var valueChanged: (String?, FormFieldCell) -> Void = {_, _ in}

	init(id: String,
		 minimalHeight: CGFloat = 60,
		 title: String? = nil,
		 value: String? = nil,
		 customSetup: @escaping (UITextView) -> Void = {_ in},
		 valueChanged: @escaping (String?, FormFieldCell) -> Void = {_, _ in}
	){
		self.title = title
		self.value = value
		self.minimalHeight = minimalHeight
		super.init(id: id)

		self.customSetup = customSetup
		self.valueChanged = valueChanged
	}
}

