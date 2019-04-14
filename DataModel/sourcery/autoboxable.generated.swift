// Generated using Sourcery 0.16.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

//	MARK:- AccountCoordinator.PageBox

final class AccountCoordinatorPageBox: NSObject {
	let unbox: AccountCoordinator.Page
	init(_ value: AccountCoordinator.Page) {
		self.unbox = value
	}
}
extension AccountCoordinator.Page {
	var boxed: AccountCoordinatorPageBox { return AccountCoordinatorPageBox(self) }
}
extension Array where Element == AccountCoordinator.Page {
	var boxed: [AccountCoordinatorPageBox] { return self.map{ $0.boxed } }
}
extension Array where Element == AccountCoordinatorPageBox {
	var unbox: [AccountCoordinator.Page] { return self.map{ $0.unbox } }
}


