import UIKit

final class LoginController: FieldsCollectionController {

	//	MARK:- View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

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
	}
}

extension LoginController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		guard let field = dataSource?.field(at: indexPath) else { return }
//
//		switch field.id {
//		case LoginDataSource.FieldId.forgotpassword.rawValue:
//			let vc = ForgotPasswordController.instantiate()
//			vc.dataSource = ForgotPasswordDataSource(user: dataSource?.user)
//			show(vc, sender: self)
//
//		default:
//			break
//		}
	}
}
