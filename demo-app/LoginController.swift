import UIKit

final class LoginController: FieldsCollectionController {

	//	MARK:- View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		applyTheme()
	}
}

private extension LoginController {
	//	MARK:- Internal

	func applyTheme() {
		view.backgroundColor = UIColor(hex: "EBEBEB")
	}

	func setupUI() {
		title = "Login"

		navigationItem.leftBarButtonItem = {
			let bbi = UIBarButtonItem(title: NSLocalizedString("Sign up", comment: ""), style: .plain, target: self, action: #selector(openAccount))
			return bbi
		}()

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
		guard
			let ds = dataSource as? LoginDataSource,
			let user = ds.user
		else { return }

		let vc = RegisterController()
		vc.dataSource = RegisterDataSource(user)

		show(vc, sender: self)
	}
}

extension LoginController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard
			let ds = dataSource as? LoginDataSource
		else { return }

		let field = ds.field(at: indexPath)

		switch field.id {
		case LoginDataSource.FieldId.forgotpassword.rawValue:
			let vc = ForgotPasswordController.instantiate()
			vc.dataSource = ForgotPasswordDataSource(user: ds.user)
			show(vc, sender: self)

		default:
			break
		}
	}
}
