//
//  InventoryCategoryCell.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 8/11/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class InventoryCategoryCell: FieldCell, NibReusableView {
	@IBOutlet private var iconView: UIImageView!

	override var isSelected: Bool {
		didSet {
			applyTheme()
		}
	}
}

extension InventoryCategoryCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate<T>(with model: SingleValueModel<T>) {
		switch model {
		case let model as SingleValueModel<InventoryCategory>:
			iconView.image = model.value.icon
		default:
			break
		}

		isSelected = model.isSelected
	}
}

private extension InventoryCategoryCell {
	func cleanup() {
		iconView.image = nil
		isSelected = false
	}

	func applyTheme() {
		if isSelected {
			iconView.tintColor = .blue
		} else {
			iconView.tintColor = .darkText
		}
	}
}

