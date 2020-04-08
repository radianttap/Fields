//
//  UIColor-Extensions.swift
//  Radiant Tap Essentials
//
//  Copyright © 2018 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/
//

import UIKit

extension UIEdgeInsets {
	public static func -(lhs: UIEdgeInsets, rhs:UIEdgeInsets) -> UIEdgeInsets {
		var insets = UIEdgeInsets.zero
		insets.top = lhs.top - rhs.top
		insets.right = lhs.right - rhs.right
		insets.bottom = lhs.bottom - rhs.bottom
		insets.left = lhs.left - rhs.left
		return insets
	}

	public static func +(lhs: UIEdgeInsets, rhs:UIEdgeInsets) -> UIEdgeInsets {
		var insets = UIEdgeInsets.zero
		insets.top = lhs.top + rhs.top
		insets.right = lhs.right + rhs.right
		insets.bottom = lhs.bottom + rhs.bottom
		insets.left = lhs.left + rhs.left
		return insets
	}
}
