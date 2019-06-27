//
//  SectionFooterView.swift
//

import UIKit

final class SectionFooterView: FieldSupplementaryView, NibReusableView {
	static let kind: String = UICollectionView.elementKindSectionFooter

	//	UI
	@IBOutlet private var textLabel: UILabel!

	private var text: String?
}


extension SectionFooterView {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
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

