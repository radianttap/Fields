//
//  LogLevel.swift
//  Log
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

///	LogLevel defines severity, larger values means more serious issue.
public enum LogLevel: Int {
	case all = 0
	case verbose = 1
	case debug = 2
	case info = 4
	case warning = 8
	case error = 16
	case catastrophic = 128

	///	Short-hand for the LogLevel, can be used in file logs.
	var mark: String {
		switch self {
		case .all:
			return "A"
		case .verbose:
			return "V"
		case .debug:
			return "D"
		case .info:
			return "I"
		case .warning:
			return "W"
		case .error:
			return "E"
		case .catastrophic:
			return "C"
		}
	}

	///	User-facing name of the log level
	var title: String {
		switch self {
		case .all:
			return NSLocalizedString("All (everything)", comment: "")
		case .verbose:
			return NSLocalizedString("Verbose", comment: "")
		case .debug:
			return NSLocalizedString("Debug", comment: "")
		case .info:
			return NSLocalizedString("Informational", comment: "")
		case .warning:
			return NSLocalizedString("Warnings", comment: "")
		case .error:
			return NSLocalizedString("Errors", comment: "")
		case .catastrophic:
			return NSLocalizedString("Catastrophic", comment: "")
		}
	}

	static let orderedLevels: [LogLevel] = [ .all, .verbose, .debug, .info, .warning, .error, .catastrophic ]
}

extension LogLevel {
	init?(mark: String) {
		switch mark {
		case "A":
			self = .all
		case "V":
			self = .verbose
		case "D":
			self = .debug
		case "I":
			self = .info
		case "W":
			self = .warning
		case "E":
			self = .error
		case "C":
			self = .catastrophic
		default:
			return nil
		}
	}
}

extension LogLevel: Comparable {
	static public func ==(lhs: LogLevel, rhs: LogLevel) -> Bool { return lhs.rawValue == rhs.rawValue }
	static public func <(lhs: LogLevel, rhs: LogLevel) -> Bool { return lhs.rawValue < rhs.rawValue }
}
