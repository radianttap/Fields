//
//  FormFieldCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class FormFieldCell: UICollectionViewCell {

	override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
		let attr = layoutAttributes.copy() as! UICollectionViewLayoutAttributes

		let labels: [UILabel] = deepGrepSubviews()
		labels.forEach { $0.preferredMaxLayoutWidth = min($0.preferredMaxLayoutWidth, bounds.width) }
		
		if #available(iOS 13, *) {
			//	works fine
		} else {
			//	without this, fittedSize (below) becomes {0,0}
			layoutIfNeeded()
		}

		let fittedSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize,
												 withHorizontalFittingPriority: UILayoutPriority.required,
												 verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
		attr.frame.size.height = ceil(fittedSize.height)
		return attr
	}
}

fileprivate extension UIView {
	func grepSubviews<T: UIView>() -> [T] {
		return subviews.compactMap { $0 as? T }
	}
	
	func deepGrepSubviews<T: UIView>() -> [T] {
		var arr: [T] = grepSubviews()
		
		let children: [T] = subviews.reduce([]) { current, v in
			var arr = current
			let x: [T] = v.deepGrepSubviews()
			arr.append(contentsOf: x)
			return arr
		}
		
		arr.append(contentsOf: children)
		return arr
	}
}
