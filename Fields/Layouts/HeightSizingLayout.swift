//
//  HeightSizingLayout.swift
//

import UIKit

class HeightSizingLayout: FullWidthLayout {

	override func prepare() {
		super.prepare()

		estimatedItemSize = itemSize
	}

	override func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
										 withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool
	{
		return preferredAttributes.frame != originalAttributes.frame
	}
}
