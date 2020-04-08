//
//  FieldsCollectionController.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class FieldsCollectionController: FieldsController {

	private(set) var collectionView: UICollectionView!
	private var layout: UICollectionViewLayout

	init(layout: UICollectionViewLayout = FieldHeightSizingLayout()) {
		self.layout = layout
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		preconditionFailure("init(coder:) has not been implemented")
	}
	
	//	View lifecycle

	override func loadView() {
		super.loadView()
		loadCollectionView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.delegate = nil
		collectionView.dataSource = nil
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		collectionView.collectionViewLayout.invalidateLayout()

		if size != view.bounds.size {
			coordinator.animate(alongsideTransition: {
				_ in
				self.collectionView.collectionViewLayout.invalidateLayout()
			}, completion: nil)
		}

		super.viewWillTransition(to: size, with: coordinator)
	}
	
	//	Entry point for DataSource object to ask VC to redraw itself

	override func renderContentUpdates() {
		if !isViewLoaded { return }

		collectionView.reloadData()
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
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false

		cv.backgroundColor = .clear

		view.addSubview(cv)
		cv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		cv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		cv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		cv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		self.collectionView = cv
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
