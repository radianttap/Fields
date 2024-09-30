//
//  FormSupplementaryView.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class FormSupplementaryView: UICollectionReusableView {
	override func awakeFromNib() {
		super.awakeFromNib()
		MainActor.assumeIsolated {
			self.postAwakeFromNib()
		}
	}
	
	@objc dynamic func postAwakeFromNib() {}

	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
		
		let fittedSize = systemLayoutSizeFitting(
			UIView.layoutFittingCompressedSize,
			withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel,
			verticalFittingPriority: UILayoutPriority.fittingSizeLevel
		)
		attr.frame.size.height = ceil(fittedSize.height)
		return attr
	}	
}
