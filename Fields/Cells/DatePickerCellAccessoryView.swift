//
//  DatePickerCellAccessoryView.swift
//  Fields-demo
//
//  Created by Aleksandar Vacić on 8/16/19.
//  Copyright © 2019 Radiant Tap. All rights reserved.
//

import UIKit

final class DatePickerCellAccessoryView: UIView, NibLoadableFinalView {
	@IBOutlet private(set) var cancelButton: UIButton!
	@IBOutlet private(set) var saveButton: UIButton!
}
