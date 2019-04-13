//
//  LoggerStub.swift
//  Log
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

///	An example dummy logger, which just prints out.
final class LoggerStub: LoggerType {
	///	A minimum accepted level. Anything bellow this is ignored.
	var minimumLevel = LogLevel.all

	//	this is the only required thing
	func log(level: LogLevel, className: String, message: @autoclosure () -> Any, _ path: String, _ function: String, line: Int) {
		if level < minimumLevel { return }

		//	print out only useful part of the path
		let cleanPath = path.components(separatedBy: "/").last ?? path

		print(
			"\n\( Date() ) : \(level.mark)",
			"\n\(cleanPath):\(line) · \(function)",
			"\n\t| \(message())"
		)
	}
}

//	now, anywhere in your code you simply
//	* adopt Loggable protocol
//	* call log(...) function

