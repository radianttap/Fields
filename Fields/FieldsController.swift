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
	private var tokenContentSizeCategoryChanged: NotificationToken?

	func renderContentUpdates() {
		if !isViewLoaded { return }

	}

	func keyboardWillShow(notification kn: KeyboardNotification) {
		let diff = max(0, kn.endFrame.height - view.safeAreaInsets.bottom)
		additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: diff, right: 0)
	}

	func keyboardWillHide(notification kn: KeyboardNotification) {
		additionalSafeAreaInsets = UIEdgeInsets.zero
	}

	func contentSizeCategoryChanged(notification kn: ContentSizeCategoryNotification) {
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
			self?.keyboardWillShow(notification: kn)
		}

		tokenKeyboardWillHide = nc.addObserver(forConvertedDescriptor: KeyboardNotification.keyboardWillHideDescriptor, queue: .main) {
			[weak self] kn in
			self?.keyboardWillHide(notification: kn)
		}

		tokenContentSizeCategoryChanged = nc.addObserver(forConvertedDescriptor: ContentSizeCategoryNotification.didChangeDescriptor, queue: .main) {
			[weak self] kn in
			self?.contentSizeCategoryChanged(notification: kn)
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
