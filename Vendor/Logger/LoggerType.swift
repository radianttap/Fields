//
//  LoggerType.swift
//  Log
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

///	Any 3rd party Logger will need to adopt this protocol, in order to be compatible with `log(...)`.
//	That can be a CocoaLumberjack, NSLogger, CleanroomLogger, Willow etc.
public protocol LoggerType {
	func log(level: LogLevel, className: String, message: @autoclosure () -> Any, _ path: String, _ function: String, line: Int)
}



///	Internal singleton instance for the Log.
///
///	On its own is useless; you need to supply with an instance of LoggerType which will actually do the work
///	(see `LoggerStub` for an example).
final class Logger {
	internal var activeLogger: LoggerType?

	//	possible to use only
	static let sharedLogger = Logger()
	private init() {}

	//	you must call this to assign the actual LoggerType
	func setupLogger(logger: LoggerType) {
		assert(activeLogger == nil, "Changing logger is disallowed to maintain consistency")
		activeLogger = logger
	}

	func log(level: LogLevel, className: String, message: @autoclosure () -> Any, _ path: String, _ function: String, line: Int) {
		activeLogger?.log(level: level, className: className, message: message(), path, function, line: line)
	}
}
