//
//  FieldCell.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 6/12/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
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
