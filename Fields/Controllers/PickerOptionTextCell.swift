//
//  PickerOptionTextCell.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 6/30/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

class PickerOptionTextCell: UICollectionViewCell, NibReusableView {
	//	UI
	@IBOutlet private var valueLabel: UILabel!
	@IBOutlet private var ccontentView: UIView!
}

extension PickerOptionTextCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with text: String) {
		valueLabel.text = text

		ccontentView.backgroundColor = isSelected ? .white : .clear
	}

	override func updateConstraints() {
		valueLabel.preferredMaxLayoutWidth = valueLabel.bounds.width
		super.updateConstraints()
	}

	override var isSelected: Bool {
		didSet {
			ccontentView.backgroundColor = isSelected ? .white : .clear
		}
	}
}

private extension PickerOptionTextCell {
	func cleanup() {
		valueLabel.text = nil
	}
}

