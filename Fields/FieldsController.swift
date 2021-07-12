//
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

	//	Entry point for DataSource object to ask VC to redraw itself

	func renderContentUpdates() {
		if !isViewLoaded { return }

	}
	
	//	Override these methods, if you need to change default behavior

    private(set) var originalAdditionalSafeAreaInsets: UIEdgeInsets = .zero
    private(set) var originalViewSafeAreaInsets: UIEdgeInsets = .zero
    private(set) var keyboardAdditionalSafeAreaInsets: UIEdgeInsets = .zero

	func keyboardWillShow(notification kn: KeyboardNotification) {
		//	Keyboard appears on top of entire UI. So the 'endFrame' we get here includes bottom safeAreaInsets already.
		//	Our embedded VC's UI is laid-out obeying safeAreaInsets of the device,
		//	thus we must subtract bottom part of safeAreaInsets from reported keyboard height.
		//	That will give us value to use for local (embedded) VC.view
		let kb = kn.endFrame.height - originalViewSafeAreaInsets.bottom
		keyboardAdditionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: kb, right: 0)
		//	Now, set VC additionalSafeAreaInsets to use the maximum values between its original or keyboard 
        additionalSafeAreaInsets = keyboardAdditionalSafeAreaInsets.union(originalAdditionalSafeAreaInsets)
	}

	func keyboardWillHide(notification kn: KeyboardNotification) {
        additionalSafeAreaInsets = originalAdditionalSafeAreaInsets
	}

	func contentSizeCategoryChanged(notification kn: ContentSizeCategoryNotification) {
	}
}

extension FieldsController {
	override func viewDidLoad() {
		super.viewDidLoad()

		setupKeyboardNotificationHandlers()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		originalViewSafeAreaInsets = view.safeAreaInsets
		originalAdditionalSafeAreaInsets = additionalSafeAreaInsets
	}
}

private extension FieldsController {
	func setupKeyboardNotificationHandlers() {
		let nc = NotificationCenter.default

		tokenKeyboardWillShow = nc.addObserver(forConvertedDescriptor: KeyboardNotification.willShow, queue: .main) {
			[weak self] kn in
			self?.keyboardWillShow(notification: kn)
		}

		tokenKeyboardWillHide = nc.addObserver(forConvertedDescriptor: KeyboardNotification.willHide, queue: .main) {
			[weak self] kn in
			self?.keyboardWillHide(notification: kn)
		}

		tokenContentSizeCategoryChanged = nc.addObserver(forConvertedDescriptor: ContentSizeCategoryNotification.didChange, queue: .main) {
			[weak self] kn in
			self?.contentSizeCategoryChanged(notification: kn)
		}
	}
}

extension FieldsController: UITextFieldDelegate {
	@objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return false
	}

	@objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		return true
	}
}
