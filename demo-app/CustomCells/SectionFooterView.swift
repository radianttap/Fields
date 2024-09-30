//
//  SectionFooterView.swift
//

import UIKit

final class SectionFooterView: FormSupplementaryView, NibReusableView {
	static let kind: String = UICollectionView.elementKindSectionFooter

	//	UI
	@IBOutlet private var textLabel: UILabel!

	private var text: String?
}


extension SectionFooterView {
	override func postAwakeFromNib() {
		super.postAwakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	override func updateConstraints() {
		textLabel.preferredMaxLayoutWidth = textLabel.bounds.width
		super.updateConstraints()
	}

	func populate(with text: String) {
		self.text = text
		render()
	}
}

private extension SectionFooterView {
	func cleanup() {
		textLabel.text = nil
	}

	func render() {
		textLabel.text = text
	}
}

