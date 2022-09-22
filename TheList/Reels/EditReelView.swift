//
//  EditReelView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI
import UIKit

struct EditReelView: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.viewController) private var viewControllerHolder: UIViewController?

	@StateObject private var vm = ViewModel()
	@State private var shoudldPickProduct = false;
	@Binding var capturedPhoto: UIImage?
	
	var body: some View {
		VStack{
			ZStack{
				Image(uiImage: capturedPhoto!).resizable()
				VStack{
					HStack{
						Spacer()
						FloatingButton(image: "close",tapAction: {
							dismiss()
						})
						.padding([.trailing,.top])
					}
					HStack{
						VStack(spacing: 15){
							HStack
							{
								Spacer()
								if vm.reel.description != "" {
									Button(action: {}, label: {Image("small-check")}).tint(.white)
								}else{
									Button(action: {}, label: {Text("Add Description")}).tint(.white)
								}
								Button(action: {
									vm.presentModal()
									self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve) {
										EditReelDescriptionView(description: $vm.reel.description, isModalPresented: $vm.isModalPresented, innerDescription: vm.reel.description)
									}
								},label: {
									Image("description")
										.resizable()
										.frame(width: 20, height: 10, alignment: .center)
								})
								.frame(width: 50, height: 50, alignment: .center)
								.background(Color(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)))
								.cornerRadius(25)
							}.opacity(vm.inPreview ? 0 : 1)
							HStack
							{
								Spacer()
								Button(action: {}, label: {Text("Add Tags")}).tint(.white)
								FloatingButton(image: "tag",tapAction: { })
							}.opacity(vm.inPreview ? 0 : 1)
							HStack
							{
								Spacer()
								Button(action: {}, label: {Image("small-check")}).opacity(vm.isValidReel ? 1 : 0)
								Button(action: {}, label: {Text("Link Products")}).tint(.white)
								FloatingButton(image: "hanger",tapAction: {
									self.shoudldPickProduct = true
								})
							}.opacity(vm.inPreview ? 0 : 1)
							HStack
							{
								Spacer()
								Button(action: {}, label: {Text("View Preview")}).tint(.white).opacity(vm.inPreview ? 0 : 1)
								FloatingButton(image: "eye",tapAction: {vm.viewPreview() })
							}
						}
					}
					.padding([.trailing])
					.padding([.top],40)
					Spacer()
					HStack{
						Text(vm.reel.description)
							.font(.system(size: 14))
							.fontWeight(.regular)
							.multilineTextAlignment(.leading)
							.padding()
							.foregroundColor(.white)
						Spacer();
					}
				}
				.opacity(vm.isModalPresented ? 0 : 1)
			}
			.preferredColorScheme(.dark)
			.cornerRadius(10)
			
			HStack{
				Text("Add a description and a minimum of 3 tags to upload post.")
					.font(.system(size: 14))
					.fontWeight(.regular)
					.multilineTextAlignment(.leading)
					.foregroundColor(.white)
					.frame(width: 200)
				Spacer()
				Button(action: {}, label: {
					HStack {
						Text("Upload")
						Image("eye")
					}
				})
				.border(vm.isValidReel ? .white : .gray, width: vm.isValidReel ? 0 : 1)
				.tint(vm.isValidReel ? .black : .gray )
			}
			.padding([.leading,.trailing],10)
			.opacity(vm.isModalPresented ? 0 : 1)
		}
		.background(Color.black)
		.navigationBarHidden(true)
		.ignoresSafeArea(.keyboard, edges: [.bottom,.top])
		.enableLightStatusBar()
		.sheet(isPresented: $shoudldPickProduct, content: {
			ProductListView()
		})
	}
}
