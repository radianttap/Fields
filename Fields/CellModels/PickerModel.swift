//
//  PickerModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model that corresponds to PickerCell instance.
///
///	This FieldModel type acts as data model for the PickerCell but also for the VC showing the list of options.
///	As such, it acts as CV DataSource & Delegate, to handle display and (de)selection of the chosen value.
class PickerModel<T: Hashable, Cell: UICollectionViewCell & ReusableView>: NSObject, FieldModel, UICollectionViewDataSource, UICollectionViewDelegate {
	///	unique identifier (across the containing form) for this field
	let id: String

	///	String to display in the title label
	var title: String?

	///	Pre-selected value of type `T`
	var value: T?

	///	List of allowed values of type `T`, to choose from.
	var values: [T] = []

	///	Transforms value of `T` into String, so it can be shown inside the field and also in expanded options list cells.
	var valueFormatter: (T?) -> String?

	///	Executted when PickerCell is tapped. It should display the `values` list.
	var displayPicker: () -> Void = {}

	///	Method called every time a value is picked
	///
	///	Default implementation does nothing.
	var valueChanged: (T?) -> Void = {_ in}

	init(id: String,
		 title: String? = nil,
		 value: T? = nil,
		 values: [T] = [],
		 valueFormatter: @escaping (T?) -> String?,
		 displayPicker: @escaping () -> Void = {},
		 valueChanged: @escaping (T?) -> Void = {_ in}
	){
		self.id = id

		self.title = title
		self.value = value
		self.values = values

		self.valueFormatter = valueFormatter

		self.displayPicker = displayPicker
		self.valueChanged = valueChanged

		super.init()
	}


	//	UICollectionViewDataSource

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return values.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell: Cell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

		switch cell {
		case let cell as PickerOptionTextCell:
			let value = values[indexPath.item]
			let s = valueFormatter(value) ?? "--"
			cell.populate(with: s)
		default:
			break
		}

		return cell
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let value = values[indexPath.item]
		valueChanged(value)
	}
}

