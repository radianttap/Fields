//
//  OptionsController.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 11/20/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class OptionsController: UICollectionViewController {

	private var options: [String] = ["One", "Two", "Three", "Four"]

    override func viewDidLoad() {
        super.viewDidLoad()

		if #available(iOS 13.0, *) {
			view.backgroundColor = UIColor.systemBackground
		} else {
			view.backgroundColor = .white
		}
		collectionView.backgroundColor = view.backgroundColor

		collectionView.register(OptionCell.self)
    }

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return options.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: OptionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
		cell.populate( options[indexPath.row] )
		return cell
	}
}
