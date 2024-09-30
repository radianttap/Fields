//
//  UIContentSizeCategory-Notifications.swift
//  Radiant Tap Essentials
//
//  Copyright © 2018 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

#if canImport(UIKit)
import UIKit

@available(iOS 10.0, *) @MainActor
public struct ContentSizeCategoryNotification: Sendable {
	public var category: UIContentSizeCategory = .unspecified

	init?(notification: Notification) {
		guard let userInfo = notification.userInfo as? [String: Any] else { return nil }

		if
			let value = userInfo[UIContentSizeCategory.newValueUserInfoKey] as? String
		{
			self.category = UIContentSizeCategory(rawValue: value)
		}
	}
}

@available(iOS 10.0, *)
public extension ContentSizeCategoryNotification {
	static let didChange = NotificationDescriptor<ContentSizeCategoryNotification>(
		name: UIContentSizeCategory.didChangeNotification,
		convert: ContentSizeCategoryNotification.init
	)
}
#endif
