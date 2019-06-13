//
//  TextFieldCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class TextFieldCell: FieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var textField: UITextField!

	private var model: TextFieldModel?
}

extension TextFieldCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: TextFieldModel) {
		self.model = model
		render()
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		if superview == nil { return }
		textField.delegate = fieldsController
	}
}

private extension TextFieldCell {
	func cleanup() {
		textField.text = nil
		textField.placeholder = nil
		titleLabel.text = nil

		textField.removeTarget(self, action: nil, for: .editingChanged)
	}

	func render() {
		if let title = model?.title {
			titleLabel.text = title
		}
		if let value = model?.value {
			textField.text = value
		}
		if let placeholder = model?.placeholder {
			textField.placeholder = placeholder
		}

		model?.customSetup( textField )

		textField.addTarget(self, action: #selector(valueChanged), for: .editingChanged)
	}

	@objc func valueChanged(_ sender: UITextField) {
		model?.value = sender.text
		model?.valueChanged(sender.text)
	}
}

