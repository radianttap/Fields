//
//  GridLayout.swift
//

import UIKit

class BaseGridLayout: UICollectionViewFlowLayout {
	///	Additional padding around the sections, which is visually added to existing layoutMargins (which is also adjusted for safeArea) of the CV
	open var baseSectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

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
		sectionInset = baseSectionInset
		itemSize = CGSize(width: 260, height: 50)
	}

	func adjustSectionInsetsForSafeArea() {
		guard let cv = collectionView else { return }
		
		var insets = baseSectionInset + cv.safeAreaInsets

		switch scrollDirection {
		case .horizontal:
			insets.left = 0
			insets.right = 0

		case .vertical:
			insets.top = 0
			insets.bottom = 0

		@unknown default:
			insets = .zero
		}
		
		self.sectionInset = insets
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
