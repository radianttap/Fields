//
//  TextCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class TextCell: FieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!
}

extension TextCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: TextModel) {
		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
		valueLabel.preferredMaxLayoutWidth = valueLabel.bounds.width
		super.updateConstraints()
	}
}

private extension TextCell {
	func cleanup() {
		titleLabel.text = nil
		valueLabel.text = nil
	}

	func render(_ model: TextModel) {
		titleLabel.text = model.title
		valueLabel.text = model.value

		model.customSetup(valueLabel)
	}
}

