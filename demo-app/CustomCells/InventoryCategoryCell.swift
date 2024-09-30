import UIKit

final class InventoryCategoryCell: FormFieldCell, NibReusableView {
	@IBOutlet private var iconView: UIImageView!

	var isChosen: Bool = false {
		didSet {
			applyTheme()
		}
	}

	private var ic: InventoryCategory?
	private var valueSelected: (InventoryCategory, FormFieldCell) -> Void = {_, _ in}
}

extension InventoryCategoryCell {
	override func postAwakeFromNib() {
		super.postAwakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate<T>(with model: SingleValueModel<T>) {
		switch model {
		case let model as SingleValueModel<InventoryCategory>:
			iconView.image = model.value.icon
			ic = model.value
			valueSelected = model.valueSelected

		default:
			break
		}

		isChosen = model.isChosen
	}
}

private extension InventoryCategoryCell {
	func cleanup() {
		iconView.image = nil
		isChosen = false
	}

	func applyTheme() {
		if isChosen {
			iconView.tintColor = .blue
		} else {
			iconView.tintColor = .darkText
		}
	}

	@IBAction func tapped(_ sender: UIControl) {
		guard let ic = ic else { return }
		valueSelected(ic, self)
	}
}
