//
//  TextViewCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class TextViewCell: FormFieldCell, NibReusableView {
	//	UI
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var textView: UITextView!

	@IBOutlet private var heightConstraint: NSLayoutConstraint!

	private var valueChanged: (String?, TextViewCell) -> Void = {_, _ in}
}

extension TextViewCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()

		textView.delegate = self
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: TextViewModel) {
		valueChanged = model.valueChanged
		render(model)
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width

		super.updateConstraints()
	}
}

private extension TextViewCell {
	func cleanup() {
		textView.text = nil
		titleLabel.text = nil
	}

	func render(_ model: TextViewModel) {
		heightConstraint.constant = model.minimalHeight

		titleLabel.text = model.title
		textView.text = model.value

		model.customSetup( textView )
	}
}

extension TextViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        fieldsCollectionController?.textViewDidBeginEditing(textView)
    }

	func textViewDidChange(_ sender: UITextView) {
		valueChanged(sender.text, self)
	}
}
