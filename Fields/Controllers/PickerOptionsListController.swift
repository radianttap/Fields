//
//  PickerOptionsListController.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 6/30/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

class PickerOptionsListController<T: Hashable, Cell: UICollectionViewCell & ReusableView>: UIViewController {

	private(set) var collectionView: UICollectionView!
	private var layout: UICollectionViewLayout

	init(layout: UICollectionViewLayout = FullWidthLayout()) {
		self.layout = layout
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private var model: PickerModel<T, Cell>?

	//	View lifecycle

	override func loadView() {
		super.loadView()
		loadCollectionView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.register(PickerOptionTextCell.self)

		title = model?.title

		collectionView.delegate = model
		collectionView.dataSource = model
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		preselect()
	}

	//	Configuration

	func populate(with model: PickerModel<T, Cell>) {
		self.model = model
		if !isViewLoaded { return }

		title = model.title

		collectionView.dataSource = model
		collectionView.delegate = model
		collectionView.reloadData()
	}

	private func preselect() {
		guard let model = model else { return }

		if
			let value = model.value,
			let index = model.values.firstIndex(of: value)
		{
			let indexPath = IndexPath(item: index, section: 0)
			collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
		}
	}
}

private extension PickerOptionsListController {
	func loadCollectionView() {
		let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
		cv.translatesAutoresizingMaskIntoConstraints = false

		cv.backgroundColor = .lightGray

		view.addSubview(cv)
		cv.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		cv.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		cv.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		cv.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		self.collectionView = cv
	}
}
