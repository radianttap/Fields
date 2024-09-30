//
//  ToggleCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class ToggleCell: FormFieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var toggle: UISwitch!

	private var valueChanged: (Bool, ToggleCell) -> Void = {_, _ in}
}

extension ToggleCell {
	override func postAwakeFromNib() {
		super.postAwakeFromNib()
		cleanup()

		toggle.addTarget(self, action: #selector(toggled), for: .valueChanged)
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: ToggleModel) {
		valueChanged = model.valueChanged
		render(model)
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
	}

	func render(_ model: ToggleModel) {
		titleLabel.text = model.title
		toggle.isOn = model.value
		model.customSetup( toggle )
	}

	@objc func toggled(_ sender: UISwitch) {
		valueChanged(sender.isOn, self)
	}
}

