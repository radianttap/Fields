//
//  BasicModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

/// Model used for totally custom cells, which are hard to fit into any of the others.
///
///	They don't have value, as it's expected that cells using them will provide case-by-case value and formatting.
class BasicModel: FieldModel {
	///	unique identifier (across the containing form) for this field
	let id: String

	init(id: String) {
		self.id = id
	}
}

