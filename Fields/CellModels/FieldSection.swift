//
//  FieldSection.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

struct FieldSection: Hashable, Identifiable {
	let id: String

	var header: String? = nil
	var fieldIds: [FieldModel.ID] = []
	var footer: String? = nil

	init(id: String, header: String? = nil, footer: String? = nil, fieldIds: [FieldModel.ID] = []) {
		self.id = id
		self.header = header
		self.footer = footer
		self.fieldIds = fieldIds
	}
}
