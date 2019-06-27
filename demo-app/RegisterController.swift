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
		dataSource?.collectionView = collectionView
		collectionView.dataSource = dataSource

		collectionView.delegate = self
	}

	func submit() {
	}
}


extension RegisterController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard
			let field = dataSource?.field(at: indexPath),
			let layout = collectionViewLayout as? HeightSizingLayout
		else { return .zero }
		var itemSize = layout.itemSize

		switch field.id {
		case RegisterDataSource.FieldId.postcode.rawValue:
			itemSize.width /= 3
		case RegisterDataSource.FieldId.city.rawValue:
			itemSize.width /= 2
		default:
			break
		}

		return itemSize
	}
}

