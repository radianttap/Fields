//
//  FormButtonCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class FormButtonCell: FormFieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var button: UIButton!

	private var action: () -> Void = {}
}

extension FormButtonCell {
	override func postAwakeFromNib() {
		super.postAwakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: FormButtonModel) {
		render(model)
	}
}

private extension FormButtonCell {
	func cleanup() {
		button.setTitle(nil, for: .normal)

		button.removeTarget(self, action: nil, for: .touchUpInside)
	}

	func render(_ model: FormButtonModel) {
		button.setTitle(model.title, for: .normal)
		model.customSetup(button)

		action = model.action

		button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
	}

	@objc func tapped(_ sender: UIButton) {
		action()
	}
}

