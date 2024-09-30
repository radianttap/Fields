import UIKit

final class OptionCell: UICollectionViewCell, NibReusableView {
	@IBOutlet private var label: UILabel!

	func populate(_ string: String) {
		label.text = string
	}
}
