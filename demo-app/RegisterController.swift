//
//  RegisterController.swift
//

import UIKit

final class RegisterController: FieldsCollectionController {

	var dataSource: RegisterDataSource?

	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		prepareDataSource()
		applyTheme()
	}
}



private extension RegisterController {
	func applyTheme() {
		view.backgroundColor = .lightGray
	}

	func prepareDataSource() {
		dataSource?.controller = self
		collectionView.dataSource = dataSource
		collectionView.delegate = self
	}

	func submit() {
	}
}


extension RegisterController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		guard
			let s = dataSource?.section(at: section),
			s.header != nil
		else { return .zero }

		var size = view.bounds.size
		size.height = 44
		return size
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		guard
			let s = dataSource?.section(at: section),
			s.footer != nil
			else { return .zero }

		var size = view.bounds.size
		size.height = 66
		return size
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard
			let field = dataSource?.field(at: indexPath),
			let layout = collectionViewLayout as? HeightSizingLayout
		else { return .zero }
		var itemSize = layout.itemSize

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

