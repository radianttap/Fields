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
			let layout = collectionViewLayout as? FieldHeightSizingLayout
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

