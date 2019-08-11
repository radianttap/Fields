//
//  FieldSection.swift
//  Fields
//
//  Copyright © 2019 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

struct FieldSection {
	let id: String

	var header: String? = nil
	var fields: [FieldModel] = []
	var footer: String? = nil

	init(id: String, header: String? = nil, footer: String? = nil, fields: [FieldModel] = []) {
		self.id = id
		self.header = header
		self.footer = footer
		self.fields = fields
	}
}
