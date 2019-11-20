//
//  GridLayout.swift
//

import UIKit

class BaseGridLayout: UICollectionViewFlowLayout {

	override func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}

	override init() {
		super.init()
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	func commonInit() {
		scrollDirection = .vertical
		headerReferenceSize = .zero
		footerReferenceSize = .zero
		minimumLineSpacing = 8
		minimumInteritemSpacing = 0
		sectionInset = .zero
		itemSize = CGSize(width: 260, height: 50)
	}

	func adjustSectionInsetsForSafeArea() {
		guard let cv = collectionView else { return }

		sectionInset = cv.safeAreaInsets

		switch scrollDirection {
		case .horizontal:
			sectionInset.left = 0
			sectionInset.right = 0

		case .vertical:
			sectionInset.top = 0
			sectionInset.bottom = 0

		@unknown default:
			sectionInset = .zero
		}
	}

	override func prepare() {
		adjustSectionInsetsForSafeArea()
		super.prepare()
	}

	override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		switch scrollDirection {
		case .horizontal:
			return newBounds.height != collectionView?.bounds.height
		case .vertical:
			return newBounds.width != collectionView?.bounds.width
		@unknown default:
			return super.shouldInvalidateLayout(forBoundsChange: newBounds)
		}
	}
}
