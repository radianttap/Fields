import UIKit

final class PickerStackItem: UIControl, NibLoadableFinalView {
	//	UI
	@IBOutlet private var nameLabel: UILabel!
	@IBOutlet private var chosenIndicatorView: UIImageView!
}

private extension PickerStackItem {
	func applyTheme() {
	}
	
	func cleanup() {
		nameLabel.text = nil
		chosenIndicatorView.isHidden = true
	}
}

extension PickerStackItem {
	override func awakeFromNib() {
		super.awakeFromNib()
		MainActor.assumeIsolated {
			cleanup()
			applyTheme()
		}
	}
	
	func populate(with string: String, attrString: NSAttributedString? = nil, isChosen: Bool = false) {
		if let attrString {
			nameLabel.text = attrString.string
			nameLabel.attributedText = attrString
		} else {
			nameLabel.attributedText = nil
			nameLabel.text = string
		}
		chosenIndicatorView.isHidden = !isChosen
	}
}
