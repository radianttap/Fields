//
//  Embeddable.swift
//  Radiant Tap Essentials
//	https://github.com/radianttap/swift-essentials
//
//  Copyright © 2016 Radiant Tap
//  MIT License · http://choosealicense.com/licenses/mit/

import UIKit

extension UIViewController {
	///	(view, parentView, useMargins) -> Void
	public typealias LayoutBlock = (UIView, UIView, Bool) -> Void
	
	///	Embeds the `view` of the given UIViewController into supplied `parentView` (or into `self.view`, if `nil`).
	///
	///	Default value of `LayoutBlock` aligns the embedded `view` with the edges of the `parentView`, using priority=999 for the bottom and trailing constraints).
	///	This helps to avoid auto-layout issues when embedding into zero-width or height container views.
	public func embed<T>(controller vc: T, into parentView: UIView?, layoutRespectingMargins: Bool = false, layout: LayoutBlock = {
		v, pv, layoutRespectingMargins in
		
		if layoutRespectingMargins {
			let constraints: [NSLayoutConstraint] = [
				v.topAnchor.constraint(equalTo: pv.layoutMarginsGuide.topAnchor),
				v.leadingAnchor.constraint(equalTo: pv.layoutMarginsGuide.leadingAnchor),
				{
					let lc = v.bottomAnchor.constraint(equalTo: pv.layoutMarginsGuide.bottomAnchor)
					lc.priority = UILayoutPriority(rawValue: 999)
					return lc
				}(),
				{
					let lc = v.trailingAnchor.constraint(equalTo: pv.layoutMarginsGuide.trailingAnchor)
					lc.priority = UILayoutPriority(rawValue: 999)
					return lc
				}()
			]
			constraints.forEach { $0.isActive = true }

		} else {
			let constraints: [NSLayoutConstraint] = [
				v.topAnchor.constraint(equalTo: pv.topAnchor),
				v.leadingAnchor.constraint(equalTo: pv.leadingAnchor),
				{
					let lc = v.bottomAnchor.constraint(equalTo: pv.bottomAnchor)
					lc.priority = UILayoutPriority(rawValue: 999)
					return lc
				}(),
				{
					let lc = v.trailingAnchor.constraint(equalTo: pv.trailingAnchor)
					lc.priority = UILayoutPriority(rawValue: 999)
					return lc
				}()
			]
			constraints.forEach { $0.isActive = true }
		}
	})
	where T: UIViewController
	{
		let container = parentView ?? self.view!
		
		addChild(vc)
		container.addSubview(vc.view)
		vc.view.translatesAutoresizingMaskIntoConstraints = false
		layout(vc.view, container, layoutRespectingMargins)
		vc.didMove(toParent: self)
		
		//	Note: after this, save the controller reference
		//	somewhere in calling scope
	}
	
	public func unembed(controller: UIViewController?) {
		guard let controller = controller else { return }
		
		controller.willMove(toParent: nil)
		if controller.isViewLoaded {
			controller.view.removeFromSuperview()
		}
		controller.removeFromParent()
		
		//	Note: don't forget to nullify your own controller instance
		//	in order to clear it out from memory
	}
}

