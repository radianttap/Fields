//
//  FullWidthLayout.swift
//

import UIKit

class FullWidthLayout: BaseGridLayout {

	override func prepare() {
		adjustSectionInsetsForSafeArea()

		if let cv = collectionView {
			let w = cv.bounds.width - (sectionInset.left + sectionInset.right)
			itemSize.width = max(w, 0)
		}

		super.prepare()
	}

}
