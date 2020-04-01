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

public class FieldHeightSizingInvalidationContext: UICollectionViewLayoutInvalidationContext {
	private var key: String { "_updateItems" }

	var updateItems: [UICollectionViewUpdateItem] {
		return (value(forKey: key) as? [UICollectionViewUpdateItem]) ?? []
	}
}

///	Custom re-implementation of `UICollectionViewFlowLayout`,
///	optimized for self-sizing along the vertical axis.
///
///	It will still consult `UICollectionViewDelegateFlowLayout` methods if they are present,
///	which gives you the ability to override width of the cells, which by default takes all available horizontal space.
///	Since `...sizeForItem` returns CGSize, the returned height will be used *only* if it's larger than calculated minimal self-sizing height.
open class FieldHeightSizingLayout: UICollectionViewLayout {
	open weak var heightSizingDelegate: FieldHeightSizingLayoutDelegate?

	open override class var invalidationContextClass: AnyClass {
		return FieldHeightSizingInvalidationContext.self
	}

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

	override open func prepare() {
		super.prepare()

		guard let cv = collectionView else { return }
		adjustSectionInsetsForSafeArea()

		if shouldRebuild {
			let w = cv.bounds.width - (sectionInset.left + sectionInset.right)
			itemSize.width = w

			//	enable self-sizing
			estimatedItemSize = itemSize

			build()

		} else if shouldRelayout {
			relayout()
		}
	}
}

extension FieldHeightSizingLayout {
	override open var collectionViewContentSize: CGSize {
		return contentSize
	}

	override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
		if (collectionView?.bounds ?? .zero).width != newBounds.width {
			return true
		}

		return super.shouldInvalidateLayout(forBoundsChange: newBounds)
	}

	open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
		if context.invalidateEverything {	//  reloadData
			shouldRebuild = true
			cachedStore.reset()

		} else if context.invalidateDataSourceCounts {	//  insert/reload/delete Items/Sections
			///	UICVL goes directly to `prepare()` after this, before `prepare(forCollectionViewUpdates:)` is called.
			///	`layoutAttributesForElements(in:)` is also called before `prepare(forCollectionViewUpdates:)`.
			///	Hence `prepare(forCollectionViewUpdates:)` is useless as it's called too late.
			///
			///	We must **now** update `cachedStore` with "future" indexPaths so that `build()` reuses proper self-sized frames.
			if let context = context as? FieldHeightSizingInvalidationContext {
				updateLayoutStore(with: context.updateItems)
			}

			shouldRebuild = true

		} else if let cv = collectionView, cv.bounds.size != currentStore.boundsSize {
			///	for some reason, `shouldInvalidateLayout(forBoundsChange:)`
			///	is not always called when rotating the device
			shouldRebuild = true
			cachedStore.reset()
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
					return false
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
			//	header/footer's indexPath
			let indexPath = IndexPath(item: 0, section: section)

			//	this section's header
			var estimatedHeaderSize = headerReferenceSize
			if let height = heightSizingDelegate?.fieldHeightSizingLayout(layout: self, estimatedHeightForHeaderInSection: section) {
				estimatedHeaderSize.height = height
			}

			let headerSize = cachedStore.header(at: indexPath)?.size ?? estimatedHeaderSize
			if headerSize.height != .zero {
				let hattributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
				hattributes.frame = CGRect(x: x, y: y, width: w, height: headerSize.height)
				currentStore.headers.insert(hattributes)
			}
			y += headerSize.height

			//	this section's cells
			let itemCount = cv.numberOfItems(inSection: section)

			x = sectionInset.left
			y += sectionInset.top
			let aw = w - (sectionInset.left + sectionInset.right)

			var lastYmax: CGFloat = y
			var currentSectionCells: [CGFloat: [UICollectionViewLayoutAttributes]] = [:]
			
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
				
				var arr = currentSectionCells[y] ?? []
				arr.append(attributes)
				currentSectionCells[y] = arr

				lastYmax = attributes.frame.maxY
				x = attributes.frame.maxX + minimumInteritemSpacing
			}

			//	when we have multiple cells in a row, make sure they are all equal height
			let orderedYKeys = currentSectionCells.keys.sorted()
			if orderedYKeys.count > 0 {
				var currentY: CGFloat = orderedYKeys.first ?? y
				for y in orderedYKeys {
					guard
						let attrs = currentSectionCells[y],
						let maxHeight = attrs.map({ $0.frame.height }).max()
						else { continue }
					
					attrs.forEach {
						var f = $0.frame
						f.origin.y = currentY
						f.size.height = maxHeight
						$0.frame = f
					}
					currentY += maxHeight
				}
				lastYmax = currentY
			}
			
			//	ok, now finish with this section and prepare for the next one
			x = 0
			y = lastYmax + sectionInset.bottom

			//	this section's footer
			var estimatedFooterSize = footerReferenceSize
			if let height = heightSizingDelegate?.fieldHeightSizingLayout(layout: self, estimatedHeightForFooterInSection: section) {
				estimatedFooterSize.height = height
			}

			let footerSize = cachedStore.footer(at: indexPath)?.size ?? estimatedFooterSize
			if footerSize.height != .zero {
				let fattributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, with: indexPath)
				fattributes.frame = CGRect(x: x, y: y, width: w, height: footerSize.height)
				currentStore.footers.insert(fattributes)
			}
			y += footerSize.height
		}

		cachedStore = currentStore

		calculateTotalContentSize()

		shouldRebuild = false
		shouldRelayout = false
	}

	func relayout() {
		guard let cv = collectionView else { return }

		var y: CGFloat = 0

		let	sectionCount = cv.numberOfSections
		for section in (0 ..< sectionCount) {
			let indexPath = IndexPath(item: 0, section: section)

			if let attr = currentStore.header(at: indexPath) {
				attr.frame.origin.y = y

				y = attr.frame.maxY
			}

			y += sectionInset.top

			let aw = cv.bounds.width - (sectionInset.left + sectionInset.right)
			var lastYmax: CGFloat = y
			var lastXmax: CGFloat = sectionInset.left

			let itemCount = cv.numberOfItems(inSection: section)
			var currentSectionCells: [CGFloat: [UICollectionViewLayoutAttributes]] = [:]
			
			for item in (0 ..< itemCount) {
				let indexPath = IndexPath(item: item, section: section)

				if let attr = currentStore.cell(at: indexPath) {
					if lastXmax + attr.frame.size.width > aw + sectionInset.left {
						y = lastYmax + minimumLineSpacing
					}

					attr.frame.origin.y = y

					var arr = currentSectionCells[y] ?? []
					arr.append(attr)
					currentSectionCells[y] = arr
					
					lastXmax = attr.frame.maxX + minimumInteritemSpacing
					lastYmax = max(y, attr.frame.maxY)
				}
			}

			//	when we have multiple cells in a row, make sure they are all equal height
			let orderedYKeys = currentSectionCells.keys.sorted()
			if orderedYKeys.count > 0 {
				var currentY: CGFloat = orderedYKeys.first ?? y
				for y in orderedYKeys {
					guard
						let attrs = currentSectionCells[y],
						let maxHeight = attrs.map({ $0.frame.height }).max()
						else { continue }
					
					attrs.forEach {
						var f = $0.frame
						f.origin.y = currentY
						f.size.height = maxHeight
						$0.frame = f
					}
					currentY += maxHeight
				}
				lastYmax = currentY
			}
			
			//	ok, now finish with this section and prepare for the next one
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

	func updateLayoutStore(with updateItems: [UICollectionViewUpdateItem]) {
		//	Note: in this method, if `indexPath.item` is `NSNotFound`, it means `updateItem` is entire section

		let deleted: [UICollectionViewUpdateItem] = updateItems.filter{ $0.updateAction == .delete }.sorted { $0.indexPathBeforeUpdate! > $1.indexPathBeforeUpdate! }
		let deletedIndexPaths = deleted.compactMap { $0.indexPathBeforeUpdate }

		for updateItem in updateItems {
			switch updateItem.updateAction {
			case .delete:
				//	remove its previously cached calculated size
				if let indexPath = updateItem.indexPathBeforeUpdate {
					if indexPath.item == NSNotFound {	//	deleteSections
						//	remove the cached layout info for removed stuff
						cachedStore.headers = cachedStore.headers.filter { $0.indexPath.section != indexPath.section }
						cachedStore.footers = cachedStore.footers.filter { $0.indexPath.section != indexPath.section }
						cachedStore.cells = cachedStore.cells.filter { $0.indexPath.section != indexPath.section }

					} else {
						if let attr = cachedStore.cell(at: indexPath) {
							cachedStore.cells.remove(attr)
						}
					}
				}

			case .insert:
				if let indexPath = updateItem.indexPathAfterUpdate {
					if indexPath.item == NSNotFound {    //    insertSections
						cachedStore.headers.forEach {
							if $0.indexPath.section < indexPath.section { return }
							$0.indexPath.section += 1
						}
						cachedStore.footers.forEach {
							if $0.indexPath.section < indexPath.section { return }
							$0.indexPath.section += 1
						}
						cachedStore.cells.forEach {
							if $0.indexPath.section < indexPath.section { return }
							$0.indexPath.section += 1
						}

					} else {
						let arr = cachedStore.cells.filter { $0.indexPath.section == indexPath.section && $0.indexPath.item >= indexPath.item }
						arr.forEach { $0.indexPath.item += 1 }
					}
				}

			case .move:
				if
					let oldIndexPath = updateItem.indexPathBeforeUpdate,
					let newIndexPath = updateItem.indexPathAfterUpdate
				{
					cachedStore.cell(at: oldIndexPath)?.indexPath = newIndexPath
				}

			case .reload:
				break

			default:	//.none
				break
			}
		}

		for indexPath in deletedIndexPaths {
			if indexPath.item == NSNotFound {    //    sections
				cachedStore.headers.forEach {
					if $0.indexPath.section < indexPath.section { return }
					$0.indexPath.section -= 1
				}
				cachedStore.footers.forEach {
					if $0.indexPath.section < indexPath.section { return }
					$0.indexPath.section -= 1
				}
				cachedStore.cells.forEach {
					if $0.indexPath.section < indexPath.section { return }
					$0.indexPath.section -= 1
				}

			} else {
				let arr = cachedStore.cells.filter { $0.indexPath.section == indexPath.section && $0.indexPath.item >= indexPath.item }
				arr.forEach { $0.indexPath.item -= 1 }
			}
		}
	}
}
