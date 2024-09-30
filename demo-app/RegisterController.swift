import UIKit

final class RegisterController: FieldsCollectionController {
	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		applyTheme()
	}
}



private extension RegisterController {
	//	MARK:- Internal

	func applyTheme() {
		view.backgroundColor = UIColor(hex: "EBEBEB")
	}

	func setupUI() {
	}
}
