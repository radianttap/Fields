//
//  ForgotPasswordController.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 8/10/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class ForgotPasswordController: FieldsController, StoryboardLoadable {
	//	UI

	@IBOutlet private var scrollView: UIScrollView!
	@IBOutlet private var emailField: TextFieldCell!

	var dataSource: ForgotPasswordDataSource? {
		didSet {
			if !isViewLoaded { return }

			prepare(dataSource)
			render(dataSource)
		}
	}

	override func renderContentUpdates() {
		if !isViewLoaded { return }

		render(dataSource)
	}
}

extension ForgotPasswordController {
	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()

		prepare(dataSource)
		render(dataSource)
	}
}

private extension ForgotPasswordController {
	func setupUI() {
		//	hack to use UICVCell subclass inside storyboard, outside of UICV
		[emailField].forEach {
			$0?.contentView.removeFromSuperview()
			$0?.translatesAutoresizingMaskIntoConstraints = false
		}
	}

	func prepare(_ dataSource: ForgotPasswordDataSource?) {
		dataSource?.controller = self
	}

	func render(_ dataSource: ForgotPasswordDataSource?) {
		guard let dataSource = dataSource else { return }

		emailField.populate(with: dataSource.emailModel)
	}

	//	MARK:- Actions

	@IBAction func send(_ sender: UIButton) {

	}

	@IBAction func openCredits(_ sender: UIButton) {
		guard let url = URL(string: "https://www.iconfinder.com/rizal999") else { return }
		UIApplication.shared.open(url)
	}
}
