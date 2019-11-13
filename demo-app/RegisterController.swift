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
		(collectionView.collectionViewLayout as? FieldHeightSizingLayout)?.heightSizingDelegate = dataSource
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
			let layout = collectionViewLayout as? FieldHeightSizingLayout,
			let section = dataSource?.section(at: indexPath.section),
			let field = dataSource?.field(at: indexPath)
		else { return .zero }

		var itemSize = layout.itemSize

		switch section.id {
		case RegisterDataSource.SectionId.prefs.rawValue:
			let w = collectionView.bounds.width
			let aw = w - (layout.sectionInset.left + layout.sectionInset.right)
			itemSize.width = max(80, aw / min(inventoryColumnSplit, CGFloat(section.fields.count)))
			itemSize.height = min(120, itemSize.width)
			return itemSize

		default:
			break
		}

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

private extension RegisterController {
    var addressColumnSplit: CGFloat {
        let c = traitCollection.preferredContentSizeCategory

        if c <= .medium {
            return 4
        } else if c <= .accessibilityMedium {
            return 2
        } else {
            return 1
        }
    }

    var personTitleColumnSplit: CGFloat {
        let c = traitCollection.preferredContentSizeCategory

        if c <= .medium {
            return 5
        } else if c <= .accessibilityMedium {
            return 4
        } else if c <= .accessibilityExtraLarge {
            return 3
        } else {
            return 1
        }
    }

	var inventoryColumnSplit: CGFloat {
        let c = traitCollection.preferredContentSizeCategory

        if c <= .medium {
            return 4
		} else if c <= .extraExtraLarge {
			return 3
        } else if c <= .accessibilityMedium {
            return 2
        } else {
            return 1
        }
	}
}
