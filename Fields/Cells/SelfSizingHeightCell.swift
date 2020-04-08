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

        if #available(iOS 13, *) {
            //    works fine
        } else {
            //    without this, fittedSize (below) becomes {0,0}
            layoutIfNeeded()
        }

        let fittedSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
                                                 withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel,
                                                 verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        attr.frame.size.height = ceil(fittedSize.height)
        return attr
    }
}
