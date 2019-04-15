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
	private let urlSession: URLSession

	init() {
		let urlSessionConfiguration: URLSessionConfiguration = {
			let c = URLSessionConfiguration.default
			c.allowsCellularAccess = true
			c.httpCookieAcceptPolicy = .never
			c.httpShouldSetCookies = false
			c.httpAdditionalHeaders = Annanow.commonHeaders
			c.requestCachePolicy = .reloadIgnoringLocalCacheData
			return c
		}()
		urlSession = URLSession(configuration: urlSessionConfiguration)

		log(level: .all, "Init")
	}
}

extension Annanow: Loggable {}

extension Annanow {
	typealias JSONResult = Result<JSON, AnnanowError>
	typealias Callback = (JSONResult) -> Void

	func call(_ endpoint: AnnanowEndpoint, callback: @escaping Callback) {
		execute(urlRequest: endpoint.urlRequest,
				callback: callback)
	}
}

private extension Annanow {
	func execute(urlRequest: URLRequest, callback: @escaping Callback) {

		let task = urlSession.dataTask(with: urlRequest) {
			[unowned self] data, urlResponse, error in

			if let urlError = error as? URLError {
				self.log(level: .error, urlError)
				callback( JSONResult.failure( AnnanowError.urlError(urlError) ) )
				return
			} else if let otherError = error {
				self.log(level: .error, otherError)
				callback( JSONResult.failure( AnnanowError.generalError(otherError) ) )
				return
			}

			guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
				self.log(level: .warning, "Non-HTTP response:\n\( urlResponse )")
				callback( JSONResult.failure( AnnanowError.invalidResponseType ) )
				return
			}

			if !(200...299).contains(httpURLResponse.statusCode) {
				self.log(level: .warning, "HTTP status code: \( httpURLResponse.statusCode )\n\( httpURLResponse )")
				#warning("Implement conversion from statusCode and/or response-body into custom AnnanowError")

				#warning("Handle re-try for connection loss and authentication errors")

				//	dummy return, for now
				callback( JSONResult.failure( AnnanowError.invalidResponseType ) )
				return
			}

			guard let data = data else {
				#warning("Is it allowed to have no response body for non-failure request?")
				self.log(level: .warning, "No response body.")
				return
			}

			do {
				let obj = try JSONSerialization.jsonObject(with: data, options: [])	//.allowFragments ..?

				guard let json = obj as? JSON else {
					//	returned response is serialized into some JSON, but it's not `JSON` (aka `[String:Any]`)
					//	(probably is JSON fragment, like an array or singular value)
					self.log(level: .error, "Response is not [String:Any]:\n\( obj )")
					callback( JSONResult.failure( AnnanowError.unexpectedResponse(httpURLResponse, "\( obj)") ) )
					return
				}

				callback( JSONResult.success(json) )

			} catch let jsonError {
				//	conversion to JSON failed.
				//	convert to string, so the caller knows what‘s actually returned
				let str = String(data: data, encoding: .utf8) ?? ""

				self.log(level: .error, "\( jsonError )\nwhen converting \( data.count ) bytes:\n\( str )")
				callback( JSONResult.failure( AnnanowError.unexpectedResponse(httpURLResponse, str) ) )
			}
		}

		task.resume()
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
