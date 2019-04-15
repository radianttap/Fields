//
//  Application-CoordinatingResponder.swift
//  AnnanowShop
//
//  Created by Aleksandar Vacić on 4/15/19.
//  Copyright © 2019 Annanow. All rights reserved.
//

import UIKit

extension UIResponder {
	//	MARK: Navigation
	//	These methods switch UI screens, so default queue is `.main`

	@objc func applicationDisplayMainUI(onQueue queue: OperationQueue? = .main, sender: Any? = nil) {
		coordinatingResponder?.applicationDisplayMainUI(onQueue: queue, sender: sender)
	}
}
