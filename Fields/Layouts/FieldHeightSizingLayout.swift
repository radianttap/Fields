//
//  FieldHeightSizingLayout.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

private struct LayoutStore {
	var cells: Set<UICollectionViewLayoutAttributes> = []
	var headers: Set<UICollectionViewLayoutAttributes> = []
	var footers: Set<UICollectionViewLayoutAttributes> = []

	/// Last `UICollectionView.bounds.size` value for which this layout store was calculated.
	var boundsSize: CGSize = .zero {
		didSet {
			if boundsSize == .zero {
				reset()
			}
		}
	}

	mutating func reset() {
		cells.removeAll()
		headers.removeAll()
		footers.removeAll()
	}

	func header(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return headers.first(where: { $0.indexPath == indexPath })
	}

	func footer(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return footers.first(where: { $0.indexPath == indexPath })
	}

	func cell(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return cells.first(where: { $0.indexPath == indexPath })
	}
}


public protocol FieldHeightSizingLayoutDelegate: class {
	func fieldHeightSizingLayout(layout: FieldHeightSizingLayout, estimatedHeightForHeaderInSection section: Int) -> CGFloat?
	func fieldHeightSizingLayout(layout: FieldHeightSizingLayout, estimatedHeightForFooterInSection section: Int) -> CGFloat?
}



///	Custom re-implementation of `UICollectionViewFlowLayout`,
///	optimized for self-sizing along the vertical axis.
///
///	It will still consult `UICollectionViewDelegateFlowLayout` methods if they are present,
///	which gives you the ability to override width of the cells, which by default takes all available horizontal space.
///	Since `...sizeForItem` returns CGSize, the returned height will be used *only* if it's larger than calculated minimal self-sizing height.
open class FieldHeightSizingLayout: UICollectionViewLayout {
	open weak var heightSizingDelegate: FieldHeightSizingLayoutDelegate?

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
	private var currentStore: LayoutStore = LayoutStore()
	private var cachedStore: LayoutStore = LayoutStore()

	///	Layout Invalidation will set this to `true` and everything will be recomputed
	private var shouldRebuild = true {
		didSet {
			if shouldRebuild { shouldRelayout = false }
		}
	}

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

		if shouldRelayout {
			relayout()

		} else if shouldRebuild {
			let w = cv.bounds.width - (sectionInset.left + sectionInset.right)
			itemSize.width = w

			//	enable self-sizing
			estimatedItemSize = itemSize


			build()
		}
	}
}

private extension FieldHeightSizingLayout {
	func build() {
		guard let cv = collectionView else { return }

		contentSize = .zero
		currentStore.reset()
		currentStore.boundsSize = cv.bounds.size

		let w = cv.bounds.width
		var x: CGFloat = 0
		var y: CGFloat = 0

		let	sectionCount = cv.numberOfSections
		for section in (0 ..< sectionCount) {
			let itemCount = cv.numberOfItems(inSection: section)
			if itemCount == 0 { continue }

			//	header/footer's indexPath
			let indexPath = IndexPath(item: 0, section: section)

			//	this section's header
			var estimatedHeaderSize = headerReferenceSize
			if let height = heightSizingDelegate?.fieldHeightSizingLayout(layout: self, estimatedHeightForHeaderInSection: section) {
				estimatedHeaderSize.height = height
			}

			let headerSize = cachedStore.header(at: indexPath)?.size ?? estimatedHeaderSize
			if headerSize != .zero {
				let hattributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
				hattributes.frame = CGRect(x: x, y: y, width: w, height: headerSize.height)
				currentStore.headers.insert(hattributes)
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
				//	do we have calculated size from previous self-sizing pass?
				var thisItemSize = cachedStore.cell(at: indexPath)?.size ?? estimatedItemSize
				if
					let customSize = (cv.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(cv, layout: self, sizeForItemAt: indexPath),
					itemSize.width != customSize.width
				{
					thisItemSize.width = customSize.width
				}

				if x + thisItemSize.width > aw + sectionInset.left {
					x = sectionInset.left
					y = lastYmax + minimumLineSpacing
				}

				let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
				attributes.frame = CGRect(x: x, y: y, width: thisItemSize.width, height: thisItemSize.height)
				currentStore.cells.insert(attributes)

				lastYmax = attributes.frame.maxY
				x = attributes.frame.maxX + minimumInteritemSpacing
			}

			x = 0
			y = lastYmax + sectionInset.bottom

			//	this section's footer
			var estimatedFooterSize = footerReferenceSize
			if let height = heightSizingDelegate?.fieldHeightSizingLayout(layout: self, estimatedHeightForFooterInSection: section) {
				estimatedFooterSize.height = height
			}

			let footerSize = cachedStore.footer(at: indexPath)?.size ?? estimatedFooterSize
			if footerSize != .zero {
				let fattributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
				fattributes.frame = CGRect(x: x, y: y, width: w, height: footerSize.height)
				currentStore.footers.insert(fattributes)
			}
			y += footerSize.height
		}

		cachedStore = currentStore

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

			let indexPath = IndexPath(item: 0, section: section)

			if let attr = currentStore.header(at: indexPath) {
				attr.frame.origin.y = y

				y = attr.frame.maxY
			}

			y += sectionInset.top

			let aw = cv.bounds.width - (sectionInset.left + sectionInset.right)
			var lastYmax: CGFloat = y
			var lastXmax: CGFloat = sectionInset.left
			for item in (0 ..< itemCount) {
				let indexPath = IndexPath(item: item, section: section)

				if let attr = currentStore.cell(at: indexPath) {
					if lastXmax + attr.frame.size.width > aw + sectionInset.left {
						y = lastYmax + minimumLineSpacing
					}

					attr.frame.origin.y = y

					lastXmax = attr.frame.maxX + minimumInteritemSpacing
					lastYmax = max(y, attr.frame.maxY)
				}
			}

			y = lastYmax + sectionInset.bottom

			if let attr = currentStore.footer(at: indexPath) {
				attr.frame.origin.y = y

				y = attr.frame.maxY
			}
		}

		cachedStore = currentStore

		calculateTotalContentSize()

		shouldRelayout = false
	}

	func calculateTotalContentSize() {
		var	f: CGRect = .zero

		for attr in currentStore.cells {
			let frame = attr.frame
			f = f.union(frame)
		}
		for attr in currentStore.headers {
			let frame = attr.frame
			f = f.union(frame)
		}
		for attr in currentStore.footers {
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
		return true
	}

	open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
		if context.invalidateEverything {	//  reloadData
			shouldRebuild = true

		} else if context.invalidateDataSourceCounts {	//  insert/reload/delete Items/Sections
			//	UICVL goes directly to `prepare()` after this, before `prepare(forCollectionViewUpdates:)` is called.
			//	`layoutAttributesForElements(in:)` is also called before `prepare(forCollectionViewUpdates:)`.

			shouldRebuild = true
		}

		super.invalidateLayout(with: context)
	}

	override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		var arr: [UICollectionViewLayoutAttributes] = []

		for attr in currentStore.cells {
			if rect.intersects(attr.frame) {
				arr.append(attr)
			}
		}
		for attr in currentStore.headers {
			if rect.intersects(attr.frame) {
				arr.append(attr)
			}
		}
		for attr in currentStore.footers {
			if rect.intersects(attr.frame) {
				arr.append(attr)
			}
		}

		return arr
	}

	override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		return currentStore.cell(at: indexPath)
	}

	override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
		switch elementKind {
		case UICollectionView.elementKindSectionHeader:
			return currentStore.header(at: indexPath)
		case UICollectionView.elementKindSectionFooter:
			return currentStore.footer(at: indexPath)
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
			currentStore.cell(at: preferredAttributes.indexPath)?.frame.size.height = preferredAttributes.frame.size.height

		case .supplementaryView:
			if let elementKind = preferredAttributes.representedElementKind {
				switch elementKind {
				case UICollectionView.elementKindSectionHeader:
					currentStore.header(at: preferredAttributes.indexPath)?.frame.size.height = preferredAttributes.frame.size.height
				case UICollectionView.elementKindSectionFooter:
					currentStore.footer(at: preferredAttributes.indexPath)?.frame.size.height = preferredAttributes.frame.size.height
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
