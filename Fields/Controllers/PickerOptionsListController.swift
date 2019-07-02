//
//  PickerOptionsListController.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

class PickerOptionsListController<T: Hashable, Cell: UICollectionViewCell & ReusableView>: UIViewController {

	private(set) var collectionView: UICollectionView!
	private var layout: UICollectionViewLayout
	private var provider: PickerOptionsProvider<T, Cell>
	private var fieldTitle: String?

	init(layout: UICollectionViewLayout = FullWidthLayout(), title: String? = nil, provider: PickerOptionsProvider<T, Cell>) {
		self.layout = layout
		self.provider = provider
		self.fieldTitle = title ?? provider.model.title
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	//	View lifecycle

	override func loadView() {
		super.loadView()
		loadCollectionView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		collectionView.register(PickerOptionTextCell.self)
		title = fieldTitle

		collectionView.delegate = provider
		collectionView.dataSource = provider
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		preselect()
	}

	//	Configuration

	private func preselect() {
		guard
			let value = provider.model.value,
			let index = provider.model.values.firstIndex(of: value)
		else { return }

		let indexPath = IndexPath(item: index, section: 0)
		collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredVertically)
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
