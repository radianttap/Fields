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

		setupUI()

		prepare(dataSource)
		render(dataSource)

		navigationItem.leftBarButtonItem = {
			let bbi = UIBarButtonItem(title: NSLocalizedString("Sign up", comment: ""), style: .plain, target: self, action: #selector(openAccount))
			return bbi
		}()

		applyTheme()
	}

	override func renderContentUpdates() {
		if !isViewLoaded { return }

		render(dataSource)
	}
}

private extension LoginController {
	//	MARK:- Internal

	func applyTheme() {
		view.backgroundColor = UIColor(hex: "EBEBEB")
	}

	func setupUI() {
		collectionView.delegate = self
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

extension LoginController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let field = dataSource?.field(at: indexPath) else { return }

		switch field.id {
		case LoginDataSource.FieldId.forgotpassword.rawValue:
			let vc = ForgotPasswordController.instantiate()
			vc.dataSource = ForgotPasswordDataSource(user: dataSource?.user)
			show(vc, sender: self)

		default:
			break
		}
	}
}
