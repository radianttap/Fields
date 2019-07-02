//
//  User.swift
//

import Foundation

struct User {
	var username: String?
	var password: String?

	var title: PersonTitle?
	var firstName: String?
	var lastName: String?

	var postalAddress: Address?

	init() {
	}
}

enum PersonTitle: String, CaseIterable {
	case Mr
	case Mrs
	case Miss
}
