//
//  ToggleCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class ToggleCell: FieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var toggle: UISwitch!

	private var model: ToggleModel?
}

extension ToggleCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: ToggleModel) {
		self.model = model
		render()
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
		super.updateConstraints()
	}
}

private extension ToggleCell {
	func cleanup() {
		toggle.isOn = false
		titleLabel.text = nil

		toggle.removeTarget(self, action: nil, for: .valueChanged)
	}

	func render() {
		if let title = model?.title {
			titleLabel.text = title
		}
		if let value = model?.value {
			toggle.isOn = value
		}

		model?.customSetup( toggle )

		toggle.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
	}

	@objc func valueChanged(_ sender: UISwitch) {
		model?.value = sender.isOn
		model?.valueChanged(sender.isOn)
	}
}

