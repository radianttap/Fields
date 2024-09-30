//
//  SectionHeaderView.swift
//

import UIKit

final class SectionHeaderView: FormSupplementaryView, NibReusableView {
	static let kind: String = UICollectionView.elementKindSectionHeader

	//	UI
	@IBOutlet private var titleLabel: UILabel!

	private var title: String?
}


extension SectionHeaderView {
	override func postAwakeFromNib() {
		super.postAwakeFromNib()
		cleanup()
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		cleanup()
	}

	override func updateConstraints() {
		titleLabel.preferredMaxLayoutWidth = titleLabel.bounds.width
		super.updateConstraints()
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
		titleLabel.text = title?.uppercased()
	}
}

