//
//  EditReelDescriptionView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import SwiftUI
import UIKit

struct EditReelDescriptionView: View {
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?
	
	@Binding var description: String
	@Binding var isModalPresented: Bool
	@State var innerDescription = ""
	@State private var charactersRemaining = 140
	var completion: ()-> Void
	func getRemainingCharacterLength() {
		self.charactersRemaining = 140 - innerDescription.count
	}

	
	var body: some View {
		VStack{
			HStack{
				Spacer()
				FloatingButton(image: ImageResources.CLOSE,tapAction: {
					completion()
					self.viewControllerHolder?.dismiss(animated: true, completion: {
						self.isModalPresented = false
						completion()
					})
				})
				.padding([.trailing,.top])
			}
			HStack{
				VStack{
					TextEditor(text: $innerDescription)
						.lineSpacing(3)
						.limitInputLength(value: $innerDescription, length: 140, completion: getRemainingCharacterLength)
						.foregroundColor(.white)
						.font(.system(size: 14))
						.frame(height: 200, alignment: .center)
						.accentColor(.white)
						.padding(5)
					HStack{
						Spacer()
						Text("\(charactersRemaining) characters left")
							.multilineTextAlignment(.trailing)
							.font(.system(size: 14))
							.foregroundColor(.white)
							.padding()
					}
				}
				.background(Color(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)))
				.cornerRadius(5)
				.padding([.leading,.trailing],20)
				.padding(.top,40)

			}
			Button(action: {
				self.viewControllerHolder?.dismiss(animated: true, completion: {
					self.description = innerDescription
					self.isModalPresented = false
					completion()
				})
			},label: {
				Image(ImageResources.CHECK)
					.resizable()
					.frame(width: 35, height: 35, alignment: .center)
			})
			.frame(width: 70, height: 70, alignment: .center)
			.background(
				Color(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5))
			)
			.cornerRadius(35)
			.padding(.top,10)
			
			Spacer()
		}
		.onTapGesture {
			UIApplication.shared.endEditing()
		}
		.navigationBarHidden(true)
		.onAppear(perform: {
			UITextView.appearance().backgroundColor = .clear
		})
		.onDisappear {
			UITextView.appearance().backgroundColor = .systemBackground
		}
	}
}
