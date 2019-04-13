//
//  DataError.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

/**
Declaration of errors that DataStorage layer can throw/return.

Since this module communicates with Services, it needs a wrapper for Errors thrown by them.
*/
enum DataError: Error {
	case generalError(Swift.Error)
	case annanowError(AnnanowError)
}
