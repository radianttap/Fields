//
//  Fields
//
//  Copyright © 2021 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit



@MainActor
protocol FieldsDataSourceable: AnyObject {
	var controller: FieldsCollectionController? { get set }
}


///	Base class which defines layout and handles diffable data source for `UICollectionView`.
///
///	Make sure to subclass this file and override the following methods:
///
///	- `registerReusableElements(for:)`
///	- `populateSnapshot(flowIdentifier:)`
///
///	You **must** call `super` when overriding these methods.
///
@MainActor
class FieldsDataSource: NSObject, FieldsDataSourceable {
	typealias GridSource = UICollectionViewDiffableDataSource<FieldSection.ID, FieldModel.ID>


	//	Dependencies
	weak var controller: FieldsCollectionController? {
		didSet { prepareView() }
	}

	var estimatedFieldHeight: CGFloat = 66
	var interSectionVerticalSpacing: CGFloat = 0

	var areSeparatorsEnabled = false

	///	Map of unique `FieldId` (raw, String) values versus cell registration for each field.
	///
	///	This is populated in `registerReusableElements(for:)`.
	var cellRegistrations: [FieldModel.ID: UICollectionView.CellRegistration<UICollectionViewCell, FieldModel.ID>] = [:]

	///	Map of `elementKind` versus supplementary view registrations.
	///
	///	This is populated in `registerReusableElements(for:)`.
	var supplementaryRegistrations: [String: UICollectionView.SupplementaryRegistration<UICollectionReusableView>] = [:]

	//	Local data model

	private(set) var gridSource: GridSource!

	//	MARK: Override points

	@objc func prepareView(flowIdentifier fid: String = UUID().uuidString) {
		guard let cv = controller?.collectionView else { return }

		registerReusableElements(for: cv)

		let layout = createLayout()
		cv.setCollectionViewLayout(layout, animated: false)
		configureCVDataSource(for: cv, flowIdentifier: fid)
	}

	///	This is where you register your custom `UICVCell` and `UICVReusableView` subclasses.
	@objc func registerReusableElements(for cv: UICollectionView) {
		supplementaryRegistrations[SeparatorLineView.kind] = UICollectionView.SupplementaryRegistration(elementKind: SeparatorLineView.kind) { _, _, _ in }
	}

	func cell(collectionView: UICollectionView, indexPath: IndexPath, item: FieldModel) -> UICollectionViewCell {
		preconditionFailure()
	}
	
	final func cell(collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: FieldModel.ID) -> UICollectionViewCell {
		guard let cellReg = cellRegistrations[itemIdentifier] else {
			preconditionFailure("Unknown cell model")
		}
		return collectionView.dequeueConfiguredReusableCell(using: cellReg, for: indexPath, item: itemIdentifier)
	}

	///	`UICVReusableView` factory.
	final func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView {
		guard let supplReg = supplementaryRegistrations[kind] else {
			preconditionFailure("Unexpected supplementary kind: \( kind )")
		}
		
		return collectionView.dequeueConfiguredReusableSupplementary(using: supplReg, for: indexPath)
	}

	///	Diffable data source for the UICV, using same signature as `GridSource` above:
	typealias Snapshot = NSDiffableDataSourceSnapshot<FieldSection.ID, FieldModel.ID>

	///	`Snapshot` factory
	func populateSnapshot(flowIdentifier fid: String) -> Snapshot {
		preconditionFailure("Must override this method and return properly populated Snapshot.")
	}

	///	By default, returns empty array.
	///
	///	Override this and setup header / footer, per section.
	@objc func layoutSectionSupplementaryItems(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> [NSCollectionLayoutBoundarySupplementaryItem] {
		return []
	}

	///	By default, returns empty array.
	///
	///	Override this and setup *global* header / footer
	@objc func layoutGlobalSupplementaryItems() -> [NSCollectionLayoutBoundarySupplementaryItem] {
		return []
	}

	///	Implement any desired custom configuration for the given section
	///
	///	By default, does nothing.
	func customConfigure(section: NSCollectionLayoutSection, atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) {
	}

	///	If not overriden, it will create full-width form field layout with estimated height of `estimatedFieldHeight`. Override `layoutSectionSupplementaryItems(atIndex:layoutEnvironment:)` to declare header/footer for section at supplied index.
	@objc func createLayout() -> UICollectionViewLayout {
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = interSectionVerticalSpacing
		config.boundarySupplementaryItems = layoutGlobalSupplementaryItems()

		let layout = UICollectionViewCompositionalLayout(
			sectionProvider: ({ [weak self] in self?.createLayoutSection(atIndex: $0, layoutEnvironment: $1) }),
			configuration: config
		)

		return layout
	}

	///	If not override, will create simple section
	@objc func createLayoutSection(atIndex sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? {
		var itemSupplementaryItems: [NSCollectionLayoutSupplementaryItem] = []
		if areSeparatorsEnabled {
			let lineAnchor = NSCollectionLayoutAnchor(edges: [.bottom, .trailing])
			let lineSize = NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1),
				heightDimension: .absolute(1)
			)
			let line = NSCollectionLayoutSupplementaryItem(
				layoutSize: lineSize,
				elementKind: SeparatorLineView.kind,
				containerAnchor: lineAnchor)

			itemSupplementaryItems = [line]
		}

		let item = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth( 1.0 ),
				heightDimension: .estimated(estimatedFieldHeight)
			),
			supplementaryItems: itemSupplementaryItems
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

		customConfigure(section: section, atIndex: sectionIndex, layoutEnvironment: layoutEnvironment)
		return section
	}

	//	MARK: Utility

	var currentSnapshot: Snapshot {
		gridSource.snapshot()
	}

	func render(_ snapshot: Snapshot, animated: Bool = true) {
		if controller == nil { return }

		gridSource.apply(snapshot, animatingDifferences: animated)
	}
}

private extension FieldsDataSource {
	func configureCVDataSource(for cv: UICollectionView, flowIdentifier fid: String) {
		gridSource = GridSource(
			collectionView: cv,
			cellProvider: { [unowned self] cv, indexPath, fieldModelId in
				return self.cell(collectionView: cv, indexPath: indexPath, itemIdentifier: fieldModelId)
			}
		)

		gridSource.supplementaryViewProvider = {
			[unowned self] cv, kind, indexPath in
			return self.supplementary(collectionView: cv, kind: kind, indexPath: indexPath)
		}

		let snapshot = populateSnapshot(flowIdentifier: fid)
		render(snapshot, animated: false)
	}
}
