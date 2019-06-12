//
//  TextFieldCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class TextFieldCell: UICollectionViewCell, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var textField: UITextField!

	var model: TextFieldModel = TextFieldModel()
}

extension TextFieldCell {
	override func awakeFromNib() {
		super.awakeFromNib()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: TextFieldModel) {
		self.model = model
		render()
	}
}

private extension TextFieldCell {
	func cleanup() {
		textField.text = nil
		titleLabel.text = nil

		model = TextFieldModel()
	}

	func render() {
		if let title = model.title {
			titleLabel.text = title
		}
		if let value = model.value {
			textField.text = value
		}
		if let placeholder = model.placeholder {
			textField.placeholder = placeholder
		}
	}
}

