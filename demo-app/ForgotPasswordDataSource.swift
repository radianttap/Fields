//
//  ForgotPasswordDataSource.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 8/10/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import Foundation

final class ForgotPasswordDataSource: NSObject {
	//    Dependencies

	weak var controller: ForgotPasswordController? {
		didSet { prepareView() }
	}

	init(user: User?) {
		self.email = user?.username
	}


	//  Data model

	private var email: String?
	private(set) var error: Error?

	private(set) lazy var emailModel: TextFieldModel = makeEmailFormModel()

	//  MARK:- Form Fields

	/// Possible form fields
	enum FieldId: String {
		case email
	}

	/// Dictionary of errors to show, per field.
	private var fieldErrors: [FieldId: String] = [:]
}

private extension ForgotPasswordDataSource {
	func prepareView() {}

	func renderContentUpdates() {
		controller?.renderContentUpdates()
	}

	func makeEmailFormModel() -> TextFieldModel {
		let model = TextFieldModel(id: FieldId.email.rawValue,
								   title: NSLocalizedString("Email (username)", comment: ""),
								   value: email)
		model.customSetup = { textField in
			textField.textContentType = .emailAddress
			textField.keyboardType = .emailAddress
		}
		model.valueChanged = {
			[weak self] string, _ in

			self?.email = string
			model.value = string
		}
		return model
	}

}
