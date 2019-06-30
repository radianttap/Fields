//
//  PickerCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class PickerCell: FieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!

	private var displayPicker: () -> Void = {}
}

extension PickerCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate<T, Cell>(with model: PickerModel<T, Cell>) {
		displayPicker = model.displayPicker
		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
		valueLabel.preferredMaxLayoutWidth = valueLabel.bounds.width
		super.updateConstraints()
	}
}

private extension PickerCell {
	func cleanup() {
		titleLabel.text = nil
		valueLabel.text = nil
	}

	func render<T, Cell>(_ model: PickerModel<T, Cell>) {
		if let title = model.title {
			titleLabel.text = title
		}
		if let value = model.value {
			valueLabel.text = model.valueFormatter(value)
		}
	}

	@IBAction func showOptions(_ sender: UIButton) {
		displayPicker()
	}
}

