//
//  LoginController.swift
//

import UIKit

final class LoginController: FieldsCollectionController {

	var dataSource: LoginDataSource? {
		didSet {
			if !isViewLoaded { return }

			prepare(dataSource)
			render(dataSource)
		}
	}

	//	MARK:- View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		prepare(dataSource)
		render(dataSource)

		navigationItem.leftBarButtonItem = {
			let bbi = UIBarButtonItem(title: NSLocalizedString("Sign up", comment: ""), style: .plain, target: self, action: #selector(openAccount))
			return bbi
		}()

		applyTheme()
	}
}



private extension LoginController {
	//	MARK:- Internal

	func applyTheme() {
		view.backgroundColor = .lightGray
	}

	func prepare(_ dataSource: LoginDataSource?) {
		dataSource?.controller = self
	}

	func render(_ dataSource: LoginDataSource?) {
		collectionView.reloadData()
	}

	//	MARK:- Actions

	@objc func openAccount(_ sender: UIBarButtonItem) {
		let layout = FieldHeightSizingLayout()
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
