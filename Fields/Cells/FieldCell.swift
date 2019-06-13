//
//  FieldCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class FieldCell: UICollectionViewCell {

	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
		layoutIfNeeded()

		let fittedSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
												 withHorizontalFittingPriority: UILayoutPriority.required,
												 verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
		attr.frame.size.height = ceil(fittedSize.height)
		attr.frame = attr.frame.integral
		return attr
	}
}
