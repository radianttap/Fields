//
//  SegmentsCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class SegmentsCell: FormFieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var segmentedControl: UISegmentedControl!
	@IBOutlet private var separator: UIView!

	private var selectedValueAtIndex: (Int?, SegmentsCell, Bool) -> Void = {_, _, _ in}
}

extension SegmentsCell {
	override func postAwakeFromNib() {
		super.postAwakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate<T: Hashable>(with model: PickerModel<T>) {
		selectedValueAtIndex = model.selectedValueAtIndex

		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width

		super.updateConstraints()
	}
}

private extension SegmentsCell {
	func cleanup() {
		titleLabel.text = nil
		segmentedControl.removeAllSegments()
	}

	func render<T>(_ model: PickerModel<T>) {
		titleLabel.text = model.title

		for (index, v) in model.values.enumerated() {
			let s = model.valueFormatter(v)
			segmentedControl.insertSegment(withTitle: s, at: index, animated: false)
		}
		if let v = model.value, let index = model.values.firstIndex(of: v) {
			segmentedControl.selectedSegmentIndex = index
		}
	}

	@IBAction func changeSelection(_ sender: UISegmentedControl) {
		selectedValueAtIndex(sender.selectedSegmentIndex, self, true)
	}
}
