//
//  ActionClosurable.swift
//  ActionClosurable
//
//  Created by Yoshitaka Seki on 2016/04/11.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//

import UIKit

@MainActor
private class Actor<T> {
	@objc func act(sender: AnyObject) { closure(sender as! T) }
	fileprivate let closure: (T) -> Void
	init(acts closure: @escaping (T) -> Void) {
		self.closure = closure
	}
}

@MainActor
private class GreenRoom {
	fileprivate var actors: [Any] = []
}

@MainActor
private var GreenRoomKey: UInt32 = 893

@MainActor
private func register<T>(_ actor: Actor<T>, to object: AnyObject) {
	let room = objc_getAssociatedObject(object, &GreenRoomKey) as? GreenRoom ?? {
		let room = GreenRoom()
		objc_setAssociatedObject(object, &GreenRoomKey, room, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		return room
		}()
	room.actors.append(actor)
}

@MainActor
public protocol ActionClosurable {}

public extension ActionClosurable where Self: AnyObject {
	func convert(closure: @escaping (Self) -> Void, toConfiguration configure: (AnyObject, Selector) -> Void) {
		let actor = Actor(acts: closure)
		configure(actor, #selector(Actor<AnyObject>.act(sender:)))
		register(actor, to: self)
	}
	static func convert(closure: @escaping (Self) -> Void, toConfiguration configure: (AnyObject, Selector) -> Self) -> Self {
		let actor = Actor(acts: closure)
		let instance = configure(actor, #selector(Actor<AnyObject>.act(sender:)))
		register(actor, to: instance)
		return instance
	}
}

extension UIBarButtonItem: ActionClosurable {}
extension UIControl: ActionClosurable {}
extension UIGestureRecognizer: ActionClosurable {}

//
//  Extensions.swift
//  ActionClosurable
//
//  Created by Yoshitaka Seki on 2016/04/11.
//  Copyright © 2016年 Yoshitaka Seki. All rights reserved.
//


extension ActionClosurable where Self: UIControl {
	public func on(_ controlEvents: UIControl.Event, closure: @escaping (Self) -> Void) {
		convert(closure: closure, toConfiguration: {
			self.addTarget($0, action: $1, for: controlEvents)
		})
	}
}

extension ActionClosurable where Self: UIButton {
	public func onTap(_ closure: @escaping (Self) -> Void) {
		convert(closure: closure, toConfiguration: {
			self.addTarget($0, action: $1, for: .touchUpInside)
		})
	}

	//	custom back button with
	public init(backButtonWithTitle title: String, closure: @escaping (Self) -> Void) {
		self.init(type: .custom)

		let img = UIImage(imageLiteralResourceName: "icon-previous")
		self.setImage(img, for: .normal)
		self.setTitle(title, for: .normal)
		self.onTap(closure)
	}
}


extension ActionClosurable where Self: UIGestureRecognizer {
	public func onGesture(_ closure: @escaping (Self) -> Void) {
		convert(closure: closure, toConfiguration: {
			self.addTarget($0, action: $1)
		})
	}
	public init(closure: @escaping (Self) -> Void) {
		self.init()
		onGesture(closure)
	}
}

extension ActionClosurable where Self: UIBarButtonItem {
	public init(barButtonSystemItem: UIBarButtonItem.SystemItem, closure: @escaping (Self) -> Void) {
		self.init(barButtonSystemItem: barButtonSystemItem, target: nil, action: nil)
		self.onTap(closure)
	}
	public init(title: String, style: UIBarButtonItem.Style = .plain, closure: @escaping (Self) -> Void) {
		self.init(title: title, style: style, target: nil, action: nil)
		self.onTap(closure)
	}
	public init(image: UIImage?, style: UIBarButtonItem.Style = .plain, closure: @escaping (Self) -> Void) {
		self.init(image: image, style: style, target: nil, action: nil)
		self.onTap(closure)
	}
	public func onTap(_ closure: @escaping (Self) -> Void) {
		convert(closure: closure, toConfiguration: {
			self.target = $0
			self.action = $1
		})
	}
}
