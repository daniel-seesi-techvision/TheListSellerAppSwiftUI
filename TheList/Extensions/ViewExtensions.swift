//
//  ViewExtensions.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import SwiftUI

struct LightStatusBarModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.onAppear {
				UIApplication.shared.statusBarStyle = .lightContent
			}
			.onDisappear {
				UIApplication.shared.statusBarStyle = .darkContent
			}
	}
}

extension View {
	func enableLightStatusBar() -> some View {
		self.modifier(LightStatusBarModifier())
	}
}


struct DarkStatusBarModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.onAppear {
				UIApplication.shared.statusBarStyle = .darkContent
			}
			.onDisappear {
				UIApplication.shared.statusBarStyle = .lightContent
			}
	}
}

extension View {
	func enableDarkStatusBar() -> some View {
		self.modifier(DarkStatusBarModifier())
	}
}
