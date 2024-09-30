import UIKit

class SeparatorLineView: UICollectionReusableView, ReusableView {
	static let kind = "SeparatorLineView"
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .separator
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
