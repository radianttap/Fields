//
//  Fields
//
//  Copyright © 2021 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit



protocol FieldsDataSourceable: AnyObject {
	var controller: FieldsCollectionController? { get set }
}


///	Base class which defines layout and handles diffable data source for `UICollectionView`.
///
///	Make sure to subclass this one and override at least:
///	- `registerReusableElements(for:)`
///	- `cell(collectionView:indexPath:item:)`
///
class FieldsDataSource: NSObject, FieldsDataSourceable {
	//	Dependencies
	weak var controller: FieldsCollectionController? {
		didSet { prepareView() }
	}

	var estimatedFieldHeight: CGFloat = 66
	var interSectionVerticalSpacing: CGFloat = 0

	//	Local data model

	private var gridSource: GridSource!

	//	MARK: Override points

	///	This is where you register your custom `UICVCell` and `UICVReusableView` subclasses.
	@objc func registerReusableElements(for cv: UICollectionView) {
		preconditionFailure("Must override this method and register cell and supplemenetary instances that UICV will use.")
	}

	///	`UICVCell` factory.
	@objc func cell(collectionView: UICollectionView, indexPath: IndexPath, item: String) -> UICollectionViewCell {
		preconditionFailure("Must override this method and return proper cell instances.")
	}

	///	`UICVReusableView` factory.
	@objc func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
		preconditionFailure("Must override this method and return proper supplementary view instances.")
	}

	///	Diffable data source for the UICV: `FieldSection.id, FieldModel.id`
	typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>

	///	`Snapshot` factory
	@objc func populateSnapshot() -> Snapshot {
		preconditionFailure("Must override this method and return properly populated Snapshot.")
	}

	///	By default, returns empty array.
	///
	///	Override this and setup header / footer, per section.
	@objc func layoutSectionSupplementaryItems(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> [NSCollectionLayoutBoundarySupplementaryItem] {
		return []
	}

	///	If not overriden, it will create full-width form field layout with estimated height of `estimatedFieldHeight`. Override `layoutSectionSupplementaryItems(atIndex:layoutEnvironment:)` to declare header/footer for section at supplied index.
	@objc func createLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout {
			sectionIndex, layoutEnvironment in

			return self.createLayoutSection(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
		}

		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = interSectionVerticalSpacing
		layout.configuration = config

		return layout
	}

	///	If not override, will create simple section
	@objc func createLayoutSection(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth( 1.0 ),
				heightDimension: .estimated(estimatedFieldHeight)
			)
		)

		let group = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .estimated(estimatedFieldHeight)
			),
			subitems: [item]
		)

		let section = NSCollectionLayoutSection(group: group)
		section.boundarySupplementaryItems = layoutSectionSupplementaryItems(atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
		return section
	}
}

private extension FieldsDataSource {
	///	`FieldSection.id, FieldModel.id`
	typealias GridSource = UICollectionViewDiffableDataSource<String, String>

	func prepareView() {
		guard
			let cv = controller?.collectionView
		else { return }

		registerReusableElements(for: cv)

		let layout = createLayout()
		cv.setCollectionViewLayout(layout, animated: false)
		configureCVDataSource(for: cv)
	}

	func configureCVDataSource(for cv: UICollectionView) {
		gridSource = GridSource(
			collectionView: cv,
			cellProvider: cell(collectionView:indexPath:item:)
		)
		gridSource.supplementaryViewProvider = supplementary(collectionView:kind:indexPath:)

		snapshot(animated: false)
	}

	func snapshot(animated: Bool) {
		let snapshot = populateSnapshot()
		gridSource.apply(snapshot, animatingDifferences: animated)
	}
}
