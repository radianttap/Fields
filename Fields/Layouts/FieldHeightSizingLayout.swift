//
//  FieldHeightSizingLayout.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

///	Custom re-implementation of `UICollectionViewFlowLayout`,
///	optimized for self-sizing along the vertical axis.
///
///	It will still consult `UICollectionViewDelegateFlowLayout` methods if they are present,
///	which gives you the ability to override width of the cells, which by default takes all available horizontal space.
///	Since `...sizeForItem` returns CGSize, the returned height will be used *only* if it's larger than calculated minimal self-sizing height.
open class FieldHeightSizingLayout: UICollectionViewLayout {

	//	MARK: Parameters (replica of UICollectionViewFlowLayout)

	open var minimumLineSpacing: CGFloat = 0
	open var minimumInteritemSpacing: CGFloat = 0
	open var sectionInset: UIEdgeInsets = .zero
	open var itemSize: CGSize = CGSize(width: 50, height: 50)
	open var estimatedItemSize: CGSize = .zero
	open var headerReferenceSize: CGSize = .zero
	open var footerReferenceSize: CGSize = .zero
	public let scrollDirection: UICollectionView.ScrollDirection = .vertical


	//	MARK: Internal layout tracking

	private var contentSize: CGSize = .zero
	private var cells: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var headers: [IndexPath: UICollectionViewLayoutAttributes] = [:]
	private var footers: [IndexPath: UICollectionViewLayoutAttributes] = [:]

	///	Cell's CGSize values picked up through `UICollectionViewDelegateFlowLayout` methods.
	private var customCellSizes: [IndexPath: CGSize] = [:]

	///	Layout Invalidation will set this to `true` and everything will be recomputed
	private var shouldRebuild = true

	///	When self-sizing is triggered, sizes will be updated in the internal layout trackers,
	///	then `relayout()` will be called to adjust the origins of the cells/headers/footers
	private var shouldRelayout = false


	//	MARK: Lifecycle

	override open func awakeFromNib() {
		super.awakeFromNib()
		commonInit()
	}

	override init() {
		super.init()
		commonInit()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}

	open func commonInit() {
		sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	}

	override open func prepare() {
		super.prepare()
		guard let cv = collectionView else { return }

		let w = cv.bounds.width - (sectionInset.left + sectionInset.right)
		itemSize.width = w

		//	enable self-sizing
		estimatedItemSize = itemSize

		if shouldRelayout {
			relayout()
		} else if shouldRebuild {
			build()
		}
	}
}

private extension FieldHeightSizingLayout {
	func reset() {
		contentSize = .zero
		cells.removeAll()
		headers.removeAll()
		footers.removeAll()
		customCellSizes.removeAll()
	}

	func build() {
		reset()
		guard let cv = collectionView else { return }

		let w = cv.bounds.width
		var x: CGFloat = 0
		var y: CGFloat = 0

		let	sectionCount = cv.numberOfSections
		for section in (0 ..< sectionCount) {
			let itemCount = cv.numberOfItems(inSection: section)
			if itemCount == 0 { continue }

			//	header/footer's indexPath
			let indexPath = IndexPath(item: NSNotFound, section: section)

			//	this section's header

			var headerSize = headerReferenceSize
			if
				let customSize = (cv.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(cv, layout: self, referenceSizeForHeaderInSection: section),
				headerSize != customSize
			{
				headerSize = customSize
			}

			if headerSize != .zero {
				let hattributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
				hattributes.frame = CGRect(x: x, y: y, width: w, height: headerSize.height)
				headers[indexPath] = hattributes
			}
			y += headerSize.height

			//	this section's cells

			x = sectionInset.left
			y += sectionInset.top
			let aw = w - (sectionInset.left + sectionInset.right)

			var lastYmax: CGFloat = y
			for item in (0 ..< itemCount) {
				//	cell's indexPath
				let indexPath = IndexPath(item: item, section: section)

				//	look for custom itemSize from the CV delegate
				var thisItemSize = itemSize
				if
					let customSize = (cv.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(cv, layout: self, sizeForItemAt: indexPath),
					itemSize != customSize
				{
					customCellSizes[indexPath] = customSize
					thisItemSize = customSize
				}

				if x + thisItemSize.width > aw + sectionInset.left {
					x = sectionInset.left
					y = lastYmax + minimumLineSpacing
				}

				let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
				attributes.frame = CGRect(x: x, y: y, width: thisItemSize.width, height: thisItemSize.height)
				cells[indexPath] = attributes

				lastYmax = attributes.frame.maxY
				x = attributes.frame.maxX + minimumInteritemSpacing
			}

			x = 0
			y = lastYmax + sectionInset.bottom

			//	this section's footer

			var footerSize = footerReferenceSize
			if
				let customSize = (cv.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(cv, layout: self, referenceSizeForFooterInSection: section),
				footerSize != customSize
			{
				footerSize = customSize
			}

			if footerSize != .zero {
				let fattributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
				fattributes.frame = CGRect(x: x, y: y, width: w, height: footerSize.height)
				footers[indexPath] = fattributes
			}
			y += footerSize.height
		}

		calculateTotalContentSize()

		shouldRebuild = false
	}

	func relayout() {
		guard let cv = collectionView else { return }

		var y: CGFloat = 0

		let	sectionCount = cv.numberOfSections
		for section in (0 ..< sectionCount) {
			let itemCount = cv.numberOfItems(inSection: section)
			if itemCount == 0 { continue }

			let indexPath = IndexPath(item: NSNotFound, section: section)

			if let attr = headers[indexPath] {
				attr.frame.origin.y = y
				headers[indexPath] = attr

				y = attr.frame.maxY
			}

			y += sectionInset.top

			let aw = cv.bounds.width - (sectionInset.left + sectionInset.right)
			var lastYmax: CGFloat = y
			var lastXmax: CGFloat = sectionInset.left
			for item in (0 ..< itemCount) {
				let indexPath = IndexPath(item: item, section: section)

				if let attr = cells[indexPath] {
					if lastXmax + attr.frame.size.width > aw + sectionInset.left {
						y = lastYmax + minimumLineSpacing
					}

					attr.frame.origin.y = y
					cells[indexPath] = attr

					lastXmax = attr.frame.maxX + minimumInteritemSpacing
					lastYmax = max(y, attr.frame.maxY)
				}
			}

			y = lastYmax + sectionInset.bottom

			if let attr = footers[indexPath] {
				attr.frame.origin.y = y
				footers[indexPath] = attr

				y = attr.frame.maxY
			}
		}

		calculateTotalContentSize()

		shouldRelayout = false
	}

	func calculateTotalContentSize() {
		var	f: CGRect = .zero

		for (_, attr) in cells {
			let frame = attr.frame
			f = f.union(frame)
		}
		for (_, attr) in headers {
			let frame = attr.frame
			f = f.union(frame)
		}
		for (_, attr) in footers {
			let frame = attr.frame
			f = f.union(frame)
		}

		self.contentSize = f.size
	}
}

extension FieldHeightSizingLayout {
	override open var collectionViewContentSize: CGSize {
		return contentSize
	}

	override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		guard let bounds = collectionView?.bounds else { return true }

		if bounds.width == newBounds.width { return false }

		shouldRebuild = true
		shouldRelayout = false
		return true
	}

	open override func invalidateLayout() {
		shouldRebuild = true
		super.invalidateLayout()
	}

	override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var arr: [UICollectionViewLayoutAttributes] = []

		for (_, attr) in cells {
			if rect.intersects(attr.frame) {
				arr.append(attr)
			}
		}
		for (_, attr) in headers {
			if rect.intersects(attr.frame) {
				arr.append(attr)
			}
		}
		for (_, attr) in footers {
			if rect.intersects(attr.frame) {
				arr.append(attr)
			}
		}

		return arr
	}

	override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cells[indexPath]
	}

	override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		switch elementKind {
		case UICollectionView.elementKindSectionHeader:
			return headers[indexPath]
		case UICollectionView.elementKindSectionFooter:
			return footers[indexPath]
		default:
			return nil
		}
	}

	override open func shouldInvalidateLayout(forPreferredLayoutAttributes preferredAttributes: UICollectionViewLayoutAttributes,
											  withOriginalAttributes originalAttributes: UICollectionViewLayoutAttributes) -> Bool
	{
		if preferredAttributes.frame.size.height == originalAttributes.frame.size.height { return false }

		switch preferredAttributes.representedElementCategory {
		case .cell:
			if
				let customSize = customCellSizes[preferredAttributes.indexPath],
				preferredAttributes.frame.height < customSize.height
			{
				return false
			}
			cells[preferredAttributes.indexPath]?.frame.size.height = preferredAttributes.frame.size.height

		case .supplementaryView:
			if let elementKind = preferredAttributes.representedElementKind {
				switch elementKind {
				case UICollectionView.elementKindSectionHeader:
					headers[preferredAttributes.indexPath]?.frame.size.height = preferredAttributes.frame.size.height
				case UICollectionView.elementKindSectionFooter:
					footers[preferredAttributes.indexPath]?.frame.size.height = preferredAttributes.frame.size.height
				default:
					break
				}
			}

		case .decorationView:
			return false

		@unknown default:
			return false
		}

		shouldRelayout = true
		return true
	}
}
