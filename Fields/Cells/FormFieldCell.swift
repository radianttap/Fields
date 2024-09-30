//
//  FormFieldCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class FormFieldCell: SelfSizingHeightCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		MainActor.assumeIsolated {
			self.postAwakeFromNib()
		}
	}
	
	@objc dynamic func postAwakeFromNib() {}

	func commonRender(_ model: FieldModel) {
		isUserInteractionEnabled = model.isUserInteractive && model.isEnabled
		
		contentView.alpha = model.isEnabled ? 1 : 0.6
	}
}
