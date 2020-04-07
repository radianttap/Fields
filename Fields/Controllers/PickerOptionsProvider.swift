//
//  PickerOptionsProvider.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

///	A derivative of the PickerModel, acts as data source and delegate for the PickerOptionsController.
///
/// Can be used for values of any data type
final class PickerOptionsProvider<T: Hashable, Cell: UICollectionViewCell & ReusableView>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {

	///	PickerModel, to fetch list of values from
	private(set) var model: PickerModel<T>

	///	PickerCell instance which initiated the display of the options list
	private var pickerCell: FormFieldCell



	init(for cell: FormFieldCell,
		 with model: PickerModel<T>
	){
		self.pickerCell = cell
		self.model = model

		super.init()
	}

	//	MARK: UICollectionViewDataSource

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return model.values.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		let cell: Cell = collectionView.dequeueReusableCell(forIndexPath: indexPath)

		switch cell {
		case let cell as PickerOptionTextCell:
			let value = model.values[indexPath.item]
			let s = model.valueFormatter(value) ?? "--"
			cell.populate(with: s)
		default:
			preconditionFailure("Unhandled PickerOption*Cell: \( cell.self )")
		}

		return cell
	}

	//	MARK: UICollectionViewDelegate

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		model.selectedValueAtIndex(indexPath.item, pickerCell)
	}
}

