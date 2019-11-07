//
//  RegisterController.swift
//

import UIKit

final class RegisterController: FieldsCollectionController {

	var dataSource: RegisterDataSource? {
		didSet {
			if !isViewLoaded { return }

			prepare(dataSource)
			render(dataSource)
		}
	}

	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()

		prepare(dataSource)
		render(dataSource)

		applyTheme()
	}

	override func renderContentUpdates() {
		if !isViewLoaded { return }

		render(dataSource)
	}
}



private extension RegisterController {
	//	MARK:- Internal

	func applyTheme() {
		view.backgroundColor = UIColor(hex: "EBEBEB")
	}

	func setupUI() {
		collectionView.delegate = self
	}

	func prepare(_ dataSource: RegisterDataSource?) {
		dataSource?.controller = self
	}

	func render(_ dataSource: RegisterDataSource?) {
		collectionView.reloadData()
	}

	//	MARK:- Actions

	func submit() {
	}
}


extension RegisterController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard
			let field = dataSource?.field(at: indexPath),
			let cell = collectionView.cellForItem(at: indexPath) as? FieldCell
		else { return }

		switch field {
		case let field as SingleValueModel<InventoryCategory>:
			field.valueSelected(cell)
		default:
			break
		}
	}
}

extension RegisterController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard
			let section = dataSource?.section(at: indexPath.section),
			let field = dataSource?.field(at: indexPath),
			let layout = collectionViewLayout as? FieldHeightSizingLayout
		else { return .zero }
		var itemSize = layout.itemSize

		switch section.id {
		case RegisterDataSource.SectionId.prefs.rawValue:
			let w = collectionView.bounds.width
			let aw = w - (layout.sectionInset.left + layout.sectionInset.right)
			itemSize.width = aw / CGFloat(section.fields.count)
			itemSize.height = itemSize.width
			return itemSize

		default:
			break
		}

		switch field.id {
		case RegisterDataSource.FieldId.postcode.rawValue, RegisterDataSource.FieldId.country.rawValue:
			itemSize.width /= 4
		case RegisterDataSource.FieldId.city.rawValue:
			itemSize.width /= 2
		case RegisterDataSource.FieldId.title.rawValue:
			itemSize.width /= 5
		case RegisterDataSource.FieldId.firstName.rawValue:
			itemSize.width *= 4/5
		default:
			break
		}

		return itemSize
	}
}

