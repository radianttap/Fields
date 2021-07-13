//
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class FieldsCollectionController: FieldsController {
	private(set) var collectionView: UICollectionView!

	//	View lifecycle

	override func loadView() {
		super.loadView()
		loadCollectionView()
	}

	var dataSource: FieldsDataSourceable? {
		didSet {
			if !isViewLoaded { return }
			prepareDataSource()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		prepareDataSource()
	}
	
	//	Override these methods, if you need to change default behavior

	override func keyboardWillShow(notification kn: KeyboardNotification) {
		let diff = max(0, kn.endFrame.height - view.safeAreaInsets.bottom)
		collectionView.contentInset.bottom = diff
	}

	override func keyboardWillHide(notification kn: KeyboardNotification) {
		collectionView.contentInset.bottom = 0
	}

	override func contentSizeCategoryChanged(notification kn: ContentSizeCategoryNotification) {
		collectionView.reloadData()
	}
}

private extension FieldsCollectionController {
	func loadCollectionView() {
		let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
		cv.translatesAutoresizingMaskIntoConstraints = false

		cv.backgroundColor = .clear

		view.addSubview(cv)
		cv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		cv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		cv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		cv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		self.collectionView = cv
	}

	func prepareDataSource() {
		collectionView.delegate = nil
		collectionView.dataSource = nil

		dataSource?.controller = self
	}
}

extension FieldsCollectionController: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		guard
			let cell: TextViewCell = textView.containingCell(),
			let indexPath = collectionView.indexPath(for: cell),
			let attr = collectionView.layoutAttributesForItem(at: indexPath)
		else { return }

		collectionView.scrollRectToVisible(attr.frame, animated: true)
	}
}
