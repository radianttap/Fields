//
//  FormTextCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class FormTextCell: FieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!
}

extension FormTextCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: FormTextModel) {
		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
		valueLabel.preferredMaxLayoutWidth = valueLabel.bounds.width
		super.updateConstraints()
	}
}

private extension FormTextCell {
	func cleanup() {
		titleLabel.text = nil
		valueLabel.text = nil
	}

	func render(_ model: FormTextModel) {
		titleLabel.text = model.title
		valueLabel.text = model.value

		model.customSetup(valueLabel)
	}
}

