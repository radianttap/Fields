//
//  PickerStackCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class PickerStackCell: FormFieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var fieldView: UIView!
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!
	@IBOutlet private var textField: UITextField!
	@IBOutlet private var stackView: UIStackView!
	@IBOutlet private var pickerButton: UIButton!

	@IBOutlet private var textFieldTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private var optionsZeroHeightConstraint: NSLayoutConstraint!

	private var displayPicker: (PickerStackCell) -> Void = {_ in}
	private var selectedValueAtIndex: (Int?, FormFieldCell, Bool) -> Void = {_, _, _ in}
	private var areOptionsExpanded = false
}

extension PickerStackCell {
	override func postAwakeFromNib() {
		super.postAwakeFromNib()
		cleanup()
		applyTheme()

		textField.isUserInteractionEnabled = false
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate<T>(with model: PickerModel<T>) {
		areOptionsExpanded = model.isPickerShown
		displayPicker = model.displayPicker
		selectedValueAtIndex = model.selectedValueAtIndex

		commonRender(model)
		render(model)
	}

	override func updateConstraints() {
		let innerWidth = bounds.width - (layoutMargins.left + layoutMargins.right)
		titleLabel.preferredMaxLayoutWidth = innerWidth

		super.updateConstraints()
	}
}

private extension PickerStackCell {
	func cleanup() {
		titleLabel.text = nil
		valueLabel.text = nil
		textField.text = nil
	}

	func applyTheme() {
		textField.tintColor = textField.textColor
	}

	func render<T>(_ model: PickerModel<T>) {
		titleLabel.text = model.title

		textField.text = model.valueFormatter(model.value)
		textField.placeholder = model.placeholder
		
		if model.isPickerShown {
			pickerButton.setImage(UIImage(systemName: "chevron.up.circle"), for: .normal)
		} else {
			pickerButton.setImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
		}

		renderOptions(model, areOptionsExpanded: model.isPickerShown)

		layoutIfNeeded()
	}

	func renderOptions<T>(_ model: PickerModel<T>, areOptionsExpanded isExpanded: Bool = false) {
		optionsZeroHeightConstraint.isActive = !isExpanded
		
		stackView.removeAllSubviews()

		model.values.enumerated().forEach {
			let item = PickerStackItem.nibInstance
			let value = model.valueFormatter($0.element) ?? "--"

			item.populate(
				with: value,
				isChosen: model.value == $0.element
			)
			item.translatesAutoresizingMaskIntoConstraints = false
			let index = $0.offset
			item.on(.touchUpInside) {
				[unowned self] _ in
				self.selectedValueAtIndex(index, self, true)
			}
			
			stackView.addArrangedSubview(item)
		}
	}

	@IBAction func toggleOptions(_ sender: UIButton) {
		displayPicker(self)
	}

	func updateLayout(animated: Bool = false) {
		if !animated {
			layoutIfNeeded()
			return
		}

		UIView.animate(withDuration: 0.3, animations: {
			[unowned self] in
			self.layoutIfNeeded()
		}, completion: {
			_ in

		})
	}
}
