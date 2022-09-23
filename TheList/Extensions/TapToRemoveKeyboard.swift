//
//  TapToRemoveKeyboard.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import SwiftUI

extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}

struct TapToRemoveKeyboard: ViewModifier{
	func body(content: Content) -> some View {
		content.toolbar {
			ToolbarItem(placement: .keyboard) {
				Button(action: {UIApplication.shared.endEditing()}, label:{ Text(StringConstants.DONE)
			}
		}
	}
}


extension View {
	func removeKeyboardOnTap() -> some View {
		self.modifier(TapToRemoveKeyboard())
	}
}
