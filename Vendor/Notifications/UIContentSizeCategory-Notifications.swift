//
//  UIContentSizeCategory-Notifications.swift
//  Radiant Tap Essentials
//
//  Copyright © 2018 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

@available(iOS 10.0, *)
struct ContentSizeCategoryNotification {
	var category: UIContentSizeCategory = .unspecified

	init?(notification: Notification) {
		guard let userInfo = notification.userInfo as? [String: Any] else { return nil }

		if
			let value = userInfo[UIContentSizeCategory.newValueUserInfoKey] as? String
		{
			self.category = UIContentSizeCategory(rawValue: value)
		}
	}
}

extension ContentSizeCategoryNotification {
	static let didChangeDescriptor = NotificationDescriptor<ContentSizeCategoryNotification>(name: UIContentSizeCategory.didChangeNotification, convert: ContentSizeCategoryNotification.init)
}
