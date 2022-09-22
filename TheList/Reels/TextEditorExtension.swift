//
//  TextEditorExtension.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import SwiftUI

struct TextEditorLimitModifer: ViewModifier {
	@Binding var value: String
	var length: Int
	var completion: () -> ()
	
	func body(content: Content) -> some View {
		content
			.onChange(of: $value.wrappedValue) {
				value = String($0.prefix(length))
				completion()
			}
	}
}

extension View {
	func limitInputLength(
		value: Binding<String>,
		length: Int,
		completion: @escaping () -> ())
	-> some View {
		self.modifier(TextEditorLimitModifer(value: value, length: length, completion: completion))
	}
}
