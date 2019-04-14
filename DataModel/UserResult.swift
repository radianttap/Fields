//
//  UserResult.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/14/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

///	Result type used for Login/ForgotPass.
typealias UserResult = Result<User, AccountError>

final class UserResultBox: NSObject {
	let unbox: UserResult
	init(_ value: UserResult) {
		self.unbox = value
	}
}
extension UserResult {
	var boxed: UserResultBox { return UserResultBox(self) }
}
