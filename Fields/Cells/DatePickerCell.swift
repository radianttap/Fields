//
//  DatePickerCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class DatePickerCell: FieldCell, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueLabel: UILabel!
	@IBOutlet private var picker: UIDatePicker!

	@IBOutlet private var setButton: UIButton!
	@IBOutlet private var saveButton: UIButton!
	@IBOutlet private var cancelButton: UIButton!

	@IBOutlet private var pickerHiddenConstraint: NSLayoutConstraint!
	private var isExpanded = false {
		didSet {
			setNeedsUpdateConstraints()
		}
	}

	private weak var formatter: DateFormatter!
	private var originalValue: Date?
	private var valueChanged: (Date?, DatePickerCell) -> Void = {_, _ in}
}

extension DatePickerCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: DatePickerModel) {
		originalValue = model.value
		formatter = model.formatter
		valueChanged = model.valueChanged
		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
		valueLabel.preferredMaxLayoutWidth = valueLabel.bounds.width
		pickerHiddenConstraint.isActive = !isExpanded

		super.updateConstraints()
	}
}

private extension DatePickerCell {
	func cleanup() {
		titleLabel.text = nil
		valueLabel.text = nil
	}

	func render(_ model: DatePickerModel) {
		titleLabel.text = model.title
		if let date = model.value {
			valueLabel.text = formatter.string(from: date)
		}

		picker.date = model.value ?? model.placeholder

		model.customSetup( picker )
	}

	@IBAction func set(_ sender: UIButton) {
		[valueLabel, setButton].forEach { $0?.isHidden = true }
		[saveButton, cancelButton].forEach { $0?.isHidden = false }

		isExpanded = true
	}

	@IBAction func cancel(_ sender: UIButton) {
		[valueLabel, setButton].forEach { $0?.isHidden = false }
		[saveButton, cancelButton].forEach { $0?.isHidden = true }

		valueChanged(originalValue, self)

		isExpanded = false
	}

	@IBAction func save(_ sender: UIButton) {
		[valueLabel, setButton].forEach { $0?.isHidden = false }
		[saveButton, cancelButton].forEach { $0?.isHidden = true }

		let date = picker.date
		valueLabel.text = formatter.string(from: date)
		valueChanged(date, self)

		isExpanded = false
	}
}
