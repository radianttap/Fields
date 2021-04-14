//
//  FormButtonModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to SubmitCell instance.
class FormButtonModel: FieldModel {
	///	unique identifier (across the containing form) for this field
	let id: String

	///	Button caption
	var title: String

	///	Custom configuration for the `UIButton`
	///
	///	Default implementation does nothing.
	var customSetup: (UIButton) -> Void = {_ in}

	///	Action to perform when button is tapped, with completion closure that must be called at the end of your `action` implementation.
	///
	///	The common UI flow here is that activity-indicator will appear and start animating when you tap; then `completed()` closure would stop indicator animation and hide it.
	var action: () -> Void = {}

	init(id: String,
		 title: String,
		 customSetup: @escaping (UIButton) -> Void = {_ in},
		 action: @escaping () -> Void = {}
	){
		self.id = id
		self.title = title

		self.customSetup = customSetup
		self.action = action
	}
}

