//
//  FieldModel.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/// Base Model used for totally custom cells, which are hard to fit into any of the others. So they only have `id`
///
///	They don't have `value`, as it's expected that cells using them will provide case-by-case value and formatting.
class FieldModel: Hashable, Identifiable, @unchecked Sendable {
	///	unique identifier (across the containing form) for this field
	let id: String
	
	var isRequired = false
	var shouldRenderRequired = true
	
	var isUserInteractive = true
	var isEnabled = true

	init(id: String) {
		self.id = id
	}

	static func == (lhs: FieldModel, rhs: FieldModel) -> Bool {
		lhs.id == rhs.id &&
		lhs.isRequired == rhs.isRequired &&
		lhs.shouldRenderRequired == rhs.shouldRenderRequired &&
		lhs.isUserInteractive == rhs.isUserInteractive &&
		lhs.isEnabled == rhs.isEnabled
	}

	func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(isRequired)
		hasher.combine(shouldRenderRequired)
		hasher.combine(isUserInteractive)
		hasher.combine(isEnabled)
	}
	
	var hasError: Bool {
		return false
	}
}
