//
//  DatePickerCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class DatePickerCell: FormFieldCell, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var valueField: UITextField!

	@IBOutlet private var setButton: UIButton!

	private weak var formatter: DateFormatter!
	private var originalValue: Date?
	private var valueChanged: (Date?, DatePickerCell) -> Void = {_, _ in}
	private var customSetup: (UIDatePicker, FormFieldCell) -> Void = {_, _ in}

	private var picker: UIDatePicker?
}

extension DatePickerCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()

		valueField.tintColor = valueField.superview?.backgroundColor
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: DatePickerModel) {
		originalValue = model.value
		formatter = model.formatter
		valueChanged = model.valueChanged
		customSetup = model.customSetup
		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width

		super.updateConstraints()
	}
}

private extension DatePickerCell {
	func cleanup() {
		titleLabel.text = nil
		valueField.text = nil
	}

	func render(_ model: DatePickerModel) {
		titleLabel.text = model.title
		if let date = model.value {
			valueField.text = formatter.string(from: date)
		}
	}

	func prepareInputAccessoryView() -> DatePickerCellAccessoryView {
		let v = DatePickerCellAccessoryView.nibInstance
		v.frame.size.height = 44

		v.saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
		v.cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
		return v
	}

	@IBAction func set(_ sender: UIButton) {
		let picker = UIDatePicker(frame: .zero)
		if #available(iOS 14.0, *) {
			picker.preferredDatePickerStyle = .wheels
		}
		if let value = originalValue {
			picker.date = value
		}
		self.picker = picker
		customSetup(picker, self)

		valueField.inputView = picker
		valueField.inputAccessoryView = prepareInputAccessoryView()
		valueField.becomeFirstResponder()

		setButton.isHidden = true
	}

	@objc func save(_ sender: UIButton) {
		defer {
			valueField.resignFirstResponder()
			picker = nil
			setButton.isHidden = false
		}

		guard let date = picker?.date else { return }
		originalValue = date

		valueField.text = formatter.string(from: date)
		valueChanged(date, self)
	}

	@objc func cancel(_ sender: UIButton) {
		defer {
			valueField.resignFirstResponder()
			picker = nil
			setButton.isHidden = false
		}

		if let date = originalValue {
			valueField.text = formatter.string(from: date)
		} else {
			valueField.text = nil
		}
		valueChanged(originalValue, self)
	}
}

