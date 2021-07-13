import UIKit

final class RegisterController: FieldsCollectionController {
	//	View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setupUI()
		applyTheme()
	}
}



private extension RegisterController {
	//	MARK:- Internal

	func applyTheme() {
		view.backgroundColor = UIColor(hex: "EBEBEB")
	}

	func setupUI() {
	}
}


/*
extension RegisterController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		guard
			let layout = collectionViewLayout as? FieldHeightSizingLayout,
			let section = dataSource?.section(at: indexPath.section),
			let field = dataSource?.field(at: indexPath)
		else { return .zero }

		var itemSize = layout.itemSize

		switch field.id {
		case RegisterDataSource.FieldId.postcode.rawValue, RegisterDataSource.FieldId.country.rawValue,
			 RegisterDataSource.FieldId.billingPostcode.rawValue, RegisterDataSource.FieldId.billingCountry.rawValue:
			itemSize.width *= 1 / addressColumnSplit

		case RegisterDataSource.FieldId.city.rawValue, RegisterDataSource.FieldId.billingCity.rawValue:
			itemSize.width *= min((1 / addressColumnSplit) * 2, 1)

		case RegisterDataSource.FieldId.title.rawValue:
			itemSize.width *= 1 / personTitleColumnSplit

		case RegisterDataSource.FieldId.firstName.rawValue:
			itemSize.width *= max(1, personTitleColumnSplit - 1) / personTitleColumnSplit

		default:
			break
		}

		return itemSize
	}
}

*/
