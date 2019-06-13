//
//  GridLayout.swift
//

import UIKit

class BaseGridLayout: UICollectionViewFlowLayout {

	override func prepare() {
		super.prepare()

		scrollDirection = .vertical
		headerReferenceSize = .zero
		footerReferenceSize = .zero
		minimumLineSpacing = 0
		minimumInteritemSpacing = 0
		sectionInset = .zero
		itemSize = CGSize(width: 50, height: 50)
	}

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		switch scrollDirection {
		case .horizontal:
			return newBounds.height != collectionView?.bounds.height
		case .vertical:
			return newBounds.width != collectionView?.bounds.width
		@unknown default:
			return true
		}
	}
}
