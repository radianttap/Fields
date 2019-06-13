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

	init(layout: UICollectionViewLayout) {
		self.layout = layout
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func loadView() {
		super.loadView()
		loadCollectionView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.delegate = nil
		collectionView.dataSource = nil
	}
}

private extension FieldsCollectionController {
	func loadCollectionView() {
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(cv)
		cv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		cv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		cv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		cv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		self.collectionView = cv
	}
}
