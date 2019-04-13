//
//  AccountError.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

/**
Declaration of errors that AccountManager can throw/return.

Must wrap errors from any lower-layers it communicates with.
*/
enum AccountError: Error {
	case dataError(DataError)
}
