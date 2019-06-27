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

		navigationItem.leftBarButtonItem = {
			let bbi = UIBarButtonItem(title: NSLocalizedString("Sign up", comment: ""), style: .plain, target: self, action: #selector(openAccount))
			return bbi
		}()
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
		let layout = HeightSizingLayout()
		layout.minimumLineSpacing = 8
		layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
		let vc = RegisterController(layout: layout)

		if let user = dataSource?.user {
			let ds = RegisterDataSource(user)
			vc.dataSource = ds
		}

		show(vc, sender: self)
	}
}
