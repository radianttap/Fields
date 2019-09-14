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

	private var valueChanged: (String?, TextFieldCell) -> Void = {_, _ in}
}

extension TextFieldCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()

		textField.addTarget(self, action: #selector(editText), for: .editingDidEnd)
		textField.addTarget(self, action: #selector(editText), for: .editingDidEndOnExit)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: TextFieldModel) {
		valueChanged = model.valueChanged
		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
		super.updateConstraints()
	}

	override func didMoveToSuperview() {
		super.didMoveToSuperview()

		textField?.delegate = fieldsController
	}
}

private extension TextFieldCell {
	func cleanup() {
		textField.text = nil
		textField.placeholder = nil
		titleLabel.text = nil
		valueChanged = {_, _ in}
	}

	func render(_ model: TextFieldModel) {
		titleLabel.text = model.title
		textField.text = model.value
		textField.placeholder = model.placeholder
		model.customSetup( textField )
	}

	@objc func editText(_ sender: UITextField) {
		valueChanged(sender.text, self)
	}
}

