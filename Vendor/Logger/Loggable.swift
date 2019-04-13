//
//  Loggable.swift
//  Log
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

/*
Credits:
http://merowing.info/2016/07/logging-in-swift/

Let’s integrate Logging in a way that:

* It can wrap any 3rd party library
* Hides the existence of singleton from the codebase
* Supports writing fully testable code
* Ability to pick which parts/modules of my code will be loggable

*/

public protocol Loggable {
	//	then when you want to log something, just call this
	func log(level: LogLevel, _ message: @autoclosure () -> Any, _ path: String, _ function: String, line: Int)

	//	or this, inside type methods
	static func log(level: LogLevel, _ message: @autoclosure () -> Any, _ path: String, _ function: String, line: Int)
}

//	now, we use protocol extension to provide default implementation of the protocol metods
public extension Loggable {
	//	(Call it inside instance or type methods.)

	//	this is the meat. if calls out to our internal singleton instance
	func log(level: LogLevel, _ message: @autoclosure () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
		//	by default, it logs:
		//	* level
		//	* tag
		//	* type of the caller
		//	* supplied message
		//	* path for the file
		//	* calling function
		//	* line number
		Logger.sharedLogger.log(level: level, className: String(describing: type(of: self)), message: message(), path, function, line: line)
	}

	static func log(level: LogLevel, _ message: @autoclosure () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
		Logger.sharedLogger.log(level: level, className: String(describing: self), message: message(), path, function, line: line)
	}
}
