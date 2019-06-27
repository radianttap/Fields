//
//  SectionHeaderView.swift
//

import UIKit

final class SectionHeaderView: FieldSupplementaryView, NibReusableView {
	static let kind: String = UICollectionView.elementKindSectionHeader

	//	UI
	@IBOutlet private var titleLabel: UILabel!

	private var title: String?
}


extension SectionHeaderView {
	override func awakeFromNib() {
		super.awakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	

	func populate(with title: String) {
		self.title = title
		render()
	}
}

private extension SectionHeaderView {
	func cleanup() {
		titleLabel.text = nil
	}

	func render() {
		titleLabel.text = title
	}
}

