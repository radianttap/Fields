//
//  ButtonCell.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

final class ButtonCell: FieldCell, NibLoadableFinalView, NibReusableView {
	//	UI
	@IBOutlet private var button: UIButton!
    @IBOutlet private var processingIndicatorView: UIActivityIndicatorView!

	private var action: (_ completed: @escaping () -> Void) -> Void = { $0() }
}

extension ButtonCell {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	func populate(with model: ButtonModel) {
		render(model)
	}
}

private extension ButtonCell {
	func cleanup() {
		button.setTitle(nil, for: .normal)
        processingIndicatorView.stopAnimating()

		button.removeTarget(self, action: nil, for: .touchUpInside)
	}

	func render(_ model: ButtonModel) {
		button.setTitle(model.title, for: .normal)
		model.customSetup(button)

		action = model.action

		button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
	}

	@objc func tapped(_ sender: UIButton) {
        processingIndicatorView.startAnimating()

		action() {
			[weak self] in
			self?.processingIndicatorView.stopAnimating()
		}
	}
}

