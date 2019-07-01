//
//  FullWidthLayout.swift
//

import UIKit

class FullWidthLayout: BaseGridLayout {

	override func prepare() {
		super.prepare()
		guard let cv = collectionView else { return }

		let w = cv.bounds.width - (sectionInset.left + sectionInset.right)
		itemSize.width = max(w, itemSize.width)
	}

}
