//
//  PickerOptionTextCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class PickerOptionTextCell: UICollectionViewCell, NibReusableView {
	//	UI
	@IBOutlet private var valueLabel: UILabel!
}

extension PickerOptionTextCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		MainActor.assumeIsolated {
			selectedBackgroundView = {
				let v = UIView(frame: .zero)
				v.backgroundColor = .white
				return v
			}()
			
			cleanup()
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with text: String) {
		valueLabel.text = text
	}

	override func updateConstraints() {
		valueLabel.preferredMaxLayoutWidth = valueLabel.bounds.width
		super.updateConstraints()
	}
}

private extension PickerOptionTextCell {
	func cleanup() {
		valueLabel.text = nil
	}
}

