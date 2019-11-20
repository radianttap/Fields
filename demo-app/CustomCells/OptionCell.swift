//
//  OptionCell.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 11/20/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class OptionCell: UICollectionViewCell, NibReusableView {
	@IBOutlet private var label: UILabel!

	func populate(_ string: String) {
		label.text = string
	}
}
