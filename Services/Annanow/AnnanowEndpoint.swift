//
//  AnnanowEndpoint.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/15/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import Foundation

enum AnnanowEndpoint {
	case login(username: String, password: String)
	case forgotPassword(email: String)
}

extension AnnanowEndpoint: Loggable {}

extension AnnanowEndpoint {
	var urlRequest: URLRequest {
		guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			fatalError("Invalid path-based URL")
		}
		comps.queryItems = queryItems(params: queryParams)

		guard let finalURL = comps.url else {
			fatalError("Invalid query items...(probably)")
		}

		var req = URLRequest(url: finalURL)
		req.httpMethod = httpMethod.rawValue
		req.allHTTPHeaderFields = headers

		#warning("Not sure does it make more sense to handle this locally and just log the error OR to throw upwards")
		req.httpBody = try! body(params: bodyParams)

		return req
	}

}

private extension AnnanowEndpoint {
	enum HTTPMethod: String {
		case GET, POST, PUT, DELETE, HEAD, CHUNK
	}

	var httpMethod: HTTPMethod {
		switch self {
		case .login:
			return .POST

		case .forgotPassword:
			return .POST
		}
	}

	///	Custom headers, that may be needed for some specific endpoints.
	///	AnnanowService will add common headers (shared by all endpoints), then it executes the request.
	var headers: [String: String] {
		var h: [String: String] = [:]

		switch self {
		default:
			h["Accept"] = "application/json"
		}

		return h
	}

	var baseURL : URL {
		#warning("Update to read the endpoint base URL from some app Configuration")
		guard let url = URL(string: "READ_FROM_CONFIG_HERE") else { fatalError("Can't create base URL!") }
		return url
	}

	var url: URL {
		let url = baseURL

		switch self {
		case .login:
			return url.appendingPathComponent("login")

		case .forgotPassword:
			return url.appendingPathComponent("forgotpassword")

		}
	}



	//	Request building

	///	Builds JSON object of parameters that will be sent as query-string. (Used by `queryItems`).
	var queryParams: JSON {
		var p: JSON = [:]

		switch self {
		case .login:
			break

		case .forgotPassword(let email):
			p["email"] = email
		}

		return p
	}

	///	Builds JSON object of parameters that will be sent as POST body.
	var bodyParams: JSON {
		var p: JSON = [:]

		switch self {
		case .login(let username, let password):
			p["email"] = username
			p["pass"] = password

		case .forgotPassword:
			break
		}

		return p
	}

	///	Builds proper, RFC-compliant query-string pairs.
	func queryItems(params: JSON) -> [URLQueryItem]? {
		if params.count == 0 { return nil }

		var arr: [URLQueryItem] = []
		for (key, value) in params {
			let qi = URLQueryItem(name: key, value: "\( value )")
			arr.append( qi )
		}
		return arr
	}

	///	Converts given JSON to Data, using JSONSerialization (its exceptions will bubble up).
	func body(params: JSON) throws -> Data {
		return try JSONSerialization.data(withJSONObject: params)
	}
}
