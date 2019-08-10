//
//  FieldsController.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class FieldsController: UIViewController {

	//	Notification handlers
	private var tokenKeyboardWillShow: NotificationToken?
	private var tokenKeyboardWillHide: NotificationToken?

	func renderContentUpdates() {
		if !isViewLoaded { return }

	}
}

extension FieldsController {
	override func viewDidLoad() {
		super.viewDidLoad()
		setupKeyboardNotificationHandlers()
	}
}

private extension FieldsController {
	func setupKeyboardNotificationHandlers() {
		let nc = NotificationCenter.default

		tokenKeyboardWillShow = nc.addObserver(forConvertedDescriptor: KeyboardNotification.keyboardWillShowDescriptor, queue: .main) {
			[weak self] kn in
			guard let self = self else { return }

			let diff = max(0, kn.endFrame.height - self.view.safeAreaInsets.bottom)
			self.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: diff, right: 0)
		}

		tokenKeyboardWillHide = nc.addObserver(forConvertedDescriptor: KeyboardNotification.keyboardWillHideDescriptor, queue: .main) {
			[weak self] kn in
			guard let self = self else { return }

			self.additionalSafeAreaInsets = UIEdgeInsets.zero
		}
	}
}

extension FieldsController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}

	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}
}
