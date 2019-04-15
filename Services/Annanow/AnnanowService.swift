//
//  AnnanowService.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/13/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

#if os(watchOS)
import Foundation
#else
import UIKit
#endif

final class Annanow {

	init() {
		log(level: .all, "Init")
	}
}

extension Annanow: Loggable {}

extension Annanow {
	typealias JSONResult = Result<JSON, AnnanowError>
	typealias Callback = (JSONResult) -> Void

	func call(endpoint: AnnanowEndpoint, callback: @escaping Callback) {
	}
}

private extension Annanow {
	///	Headers, added by URLSession, to each URLRequest instance
	static let commonHeaders: [String: String] = {
		return [
			"User-Agent": userAgent,
			"Accept-Charset": "utf-8",
			"Accept-Encoding": "gzip, deflate"
		]
	}()

	static var userAgent: String = {
		#if os(watchOS)
		let osName = "watchOS"
		let osVersion = ""
		let deviceVersion = "Apple Watch"
		#else
		let osName = UIDevice.current.systemName
		let osVersion = UIDevice.current.systemVersion
		let deviceVersion = UIDevice.current.model
		#endif
		let locale = Locale.current.identifier
		return "\( Bundle.appName ) \( Bundle.appVersion ) (\( Bundle.appBuild )); \( deviceVersion ); \( osName ) \( osVersion ); \( locale )"
	}()
}
