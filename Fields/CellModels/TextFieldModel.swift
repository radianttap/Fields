//
//  TextFieldModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

struct TextFieldModel: FieldModel {
	let id: String

	var title: String?
	var value: String?
	var placeholder: String?
	var customSetup: (UITextField) -> Void

	init(id: String, title: String? = nil, value: String? = nil, placeholder: String? = nil, customSetup: @escaping (UITextField) -> Void = {_ in}) {
		self.id = id

		self.title = title
		self.value = value
		self.placeholder = placeholder

		self.customSetup = customSetup
	}
}

