//
//  SelfSizingHeightCell.swift
//  Fields
//
//  Copyright © 2018 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class SelfSizingHeightCell: UICollectionViewCell {
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
