//
//  User.swift
//

import Foundation

struct User: Equatable {
	var username: String?
	var password: String?

	var title: PersonTitle?
	var firstName: String?
	var lastName: String?

	var postalAddress: Address?
	var billingAddress: Address?

	var dateOfBirth: Date?

	init() {
	}
}

enum PersonTitle: String, CaseIterable {
	case Mr
	case Mrs
	case Miss
}
