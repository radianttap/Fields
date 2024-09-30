//
//  Notifying.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import Foundation

public class NotificationToken {
	public let token: NSObjectProtocol
	public let center: NotificationCenter
	
	public init(token: NSObjectProtocol, center: NotificationCenter? = nil) {
		self.token = token
		self.center = center ?? NotificationCenter.default
	}
	
	deinit {
		center.removeObserver(token)
	}
}

public struct NotificationDescriptor<A>: @unchecked Sendable {
	public let name: Notification.Name
	public var convert: (Notification) -> A? = {_ in return nil }
}

extension NotificationDescriptor {
	public init(name: Notification.Name) {
		self.name = name
	}
}

extension NotificationCenter {
	public func addObserver<A: Sendable>(for descriptor: NotificationDescriptor<A>,
							   queue: OperationQueue? = nil,
							   using block: @escaping @Sendable (A) -> ()) -> NotificationToken {
		
		return NotificationToken(
			token: addObserver(forName: descriptor.name, object: nil, queue: queue, using: {
				note in
				guard let object = note.object as? A else { return }
				block(object)
			}),
			center: self
		)
	}
	
	///	Use this to observe system Notifications. `A` must have proper `convert(Notification) -> A?` implementation
	public func addObserver<A: Sendable>(forConvertedDescriptor descriptor: NotificationDescriptor<A>,
						queue: OperationQueue? = nil,
						using block: @escaping @Sendable (A) -> ()) -> NotificationToken {
		
		return NotificationToken(
			token: addObserver(forName: descriptor.name, object: nil, queue: queue, using: {
				note in
				guard let object = descriptor.convert(note) else { return }
				block(object)
			}),
			center: self
		)
	}
	
	public func post<A>(_ descriptor: NotificationDescriptor<A>, value: A) {
		post(name: descriptor.name, object: value)
	}
}

