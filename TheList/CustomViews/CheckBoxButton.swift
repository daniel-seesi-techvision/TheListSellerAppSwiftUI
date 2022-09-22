//
//  CheckBoxButton.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import SwiftUI
struct CheckBoxButton : View{
	@Binding var checked: Bool;
	var body: some View {
		ZStack{
			Button(action: {}, label: {})
				.frame(width: 30, height: 30, alignment: .center)
				.background(checked ? .black : .clear)
				.cornerRadius(3)
				.border(checked ? .black : .gray, width: 1)

				Image("check")
					.resizable()
					.frame(width: 15, height: 15, alignment: .center)
					.opacity(checked ? 1 : 0)
		}
		.onTapGesture {
			checked.toggle()
		}
		
	}
}
