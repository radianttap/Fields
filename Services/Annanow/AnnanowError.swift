//
//  AnnanowError.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

/**
	Declaration of errors that Annanow service and throw/return.

	Since this module uses networking, it should pass-through any URLErrors that happen.
*/
enum AnnanowError: Error {
	case generalError(Swift.Error)
	case urlError(URLError)
}
