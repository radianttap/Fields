//
//  UIKeyboard-Notifications.swift
//  Radiant Tap Essentials
//
//  Copyright © 2017 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

#if canImport(UIKit)
import UIKit

//	@available(iOS 3.2, *)
//	public let UIKeyboardFrameBeginUserInfoKey: String
// NSValue of CGRect

//	@available(iOS 3.2, *)
//	public let UIKeyboardFrameEndUserInfoKey: String
// NSValue of CGRect

//	@available(iOS 3.0, *)
//	public let UIKeyboardAnimationDurationUserInfoKey: String
// NSNumber of double

//	@available(iOS 3.0, *)
//	public let UIKeyboardAnimationCurveUserInfoKey: String
// NSNumber of NSUInteger (UIViewAnimationCurve)

//	@available(iOS 9.0, *)
//	public let UIKeyboardIsLocalUserInfoKey: String
// NSNumber of BOOL

@MainActor
public struct KeyboardNotification: Sendable {
	public var beginFrame: CGRect = .zero
	public var endFrame: CGRect = .zero
	public var animationCurve: UIView.AnimationCurve = .linear
	public var animationDuration: TimeInterval = 0.3
	public var isLocalForCurrentApp: Bool = false

	init?(notification: Notification) {
		guard let userInfo = notification.userInfo as? [String: Any] else { return nil }

		if let value = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
			beginFrame = value.cgRectValue
		}
		if let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			endFrame = value.cgRectValue
		}
		if let value = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int, let curve = UIView.AnimationCurve(rawValue: value) {
			animationCurve = curve
		}
		if let value = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval {
			animationDuration = value
		}
		if let value = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? Bool {
			isLocalForCurrentApp = value
		}
	}
}

public extension KeyboardNotification {
	static let willShow = NotificationDescriptor<KeyboardNotification>(name: UIResponder.keyboardWillShowNotification, convert: KeyboardNotification.init)
	static let didShow = NotificationDescriptor<KeyboardNotification>(name: UIResponder.keyboardDidShowNotification, convert: KeyboardNotification.init)

	static let willHide = NotificationDescriptor<KeyboardNotification>(name: UIResponder.keyboardWillHideNotification, convert: KeyboardNotification.init)
	static let didHide = NotificationDescriptor<KeyboardNotification>(name: UIResponder.keyboardDidHideNotification, convert: KeyboardNotification.init)
}
#endif
