//
//  ViewControllerHolder.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import SwiftUI
import UIKit

struct ViewControllerHolder {
	weak var value: UIViewController?
}

struct ViewControllerKey: EnvironmentKey {
	static var defaultValue: ViewControllerHolder {
		return ViewControllerHolder(value: UIApplication.shared.windows.first?.rootViewController)
	}
}

extension EnvironmentValues {
	var viewController: UIViewController? {
		get { return self[ViewControllerKey.self].value }
		set { self[ViewControllerKey.self].value = newValue }
	}
}

extension UIViewController {
	func present<Content: View>(style: UIModalPresentationStyle = .overCurrentContext, transitionStyle: UIModalTransitionStyle = .coverVertical, @ViewBuilder builder: () -> Content) {
		let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
		toPresent.modalPresentationStyle = style
		toPresent.modalTransitionStyle = transitionStyle
		toPresent.view.backgroundColor = UIColor.clear
		toPresent.rootView = AnyView(
			builder()
				.environment(\.viewController, toPresent)
		)
		self.present(toPresent, animated: true, completion: nil)
	}
}

