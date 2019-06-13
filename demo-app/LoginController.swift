//
//  LoginController.swift
//

import UIKit

final class LoginController: FieldsCollectionController {

	var dataSource: LoginDataSource?

	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		prepareDataSource()
		applyTheme()
	}
}



private extension LoginController {
	func applyTheme() {
		view.backgroundColor = .lightGray
	}

	func prepareDataSource() {
		dataSource?.collectionView = collectionView
		collectionView.dataSource = dataSource
	}

	func submit() {
//		collectionView.endEditing(true)


	}

	@objc func openAccount(_ sender: UIBarButtonItem) {
//		let vc = RegisterController()
//		show(vc, sender: self)
	}
}
