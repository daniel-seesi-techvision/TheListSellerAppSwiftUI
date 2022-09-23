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
	
	@EnvironmentObject var appState: AppState
	@StateObject private var vm = ViewModel()
	@State private var shoudldPickProduct = false;
	@Binding var capturedPhoto: UIImage?
	
	var layout = [ GridItem(.fixed(120)),]
	var body: some View {
		VStack{
			ZStack{
				Image(uiImage: capturedPhoto!).resizable()
				VStack{
					HStack{
						Spacer()
						FloatingButton(image: ImageResources.CLOSE,tapAction: {
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
									Button(action: {}, label: {Image(ImageResources.SMALL_CHECK)}).tint(.white)
								}else{
									Button(action: {}, label: {Text(StringConstants.DESCRIPTION_LABEL)}).tint(.white)
								}
								Button(action: {
									vm.presentModal()
									self.viewControllerHolder?.present(style: .overCurrentContext, transitionStyle: .crossDissolve) {
										EditReelDescriptionView(
											description: $vm.reel.description,
											isModalPresented: $vm.isModalPresented,
											innerDescription: vm.reel.description,
											completion: { vm.validateReel() } )
									}
								},label: {
									Image(ImageResources.DESCRIPTION)
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
								Button(action: {}, label: {Text(StringConstants.TAG_LABEL)}).tint(.white)
								FloatingButton(image: ImageResources.TAG,tapAction: { })
							}.opacity(vm.inPreview ? 0 : 1)
							HStack
							{
								Spacer()
								if vm.linkedProducts.count > 0 {
									Button(action: {}, label: {Image(ImageResources.SMALL_CHECK)}).tint(.white)
								}
								else{
									Button(action: {}, label: {Text(StringConstants.LINK_PRODUCT_LABEL)}).tint(.white)
								}
								FloatingButton(image: ImageResources.HANGER,tapAction: {
									self.shoudldPickProduct = true
								})
							}.opacity(vm.inPreview ? 0 : 1)
							HStack
							{
								Spacer()
								Button(action: {}, label: {Text(StringConstants.PREVIEW_REEL_LABEL)}).tint(.white).opacity(vm.inPreview ? 0 : 1)
								FloatingButton(image: ImageResources.EYE,tapAction: {vm.viewPreview() })
							}
						}
					}
					.padding([.trailing])
					.padding([.top],40)
					
					ScrollView(.horizontal) {
						LazyHGrid(rows: layout){
							ForEach(vm.linkedProducts, id: \.self) { item in
								AsyncImage(url: URL(string: item.imageUrl)) { image in
									image
										.resizable()
										.aspectRatio(contentMode: .fill)
										.background(.clear)
								} placeholder: {
									ProgressView()
								}.padding(.horizontal)
							}
						}
					}
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
				Text(StringConstants.CAMAERA_INSTRUCTION_3)
					.font(.system(size: 14))
					.fontWeight(.regular)
					.multilineTextAlignment(.leading)
					.foregroundColor(.white)
					.frame(width: 200)
				Spacer()
				HStack{
					Button(action: {
						if vm.isValidReel {
							vm.saveReel(photo: $capturedPhoto,completion: {
								// FIXME: navigate to root view
								self.appState.moveToStore = true
							})
						}
					}, label: {
						Text(StringConstants.UPLOAD)
						if vm.isValidReel {
							Image(ImageResources.BLACK_CHECK)
						}
					})
				}
				.frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
				.cornerRadius(25)
				.tint(vm.isValidReel ? .black : .gray )
				.background(vm.isValidReel ? .white : .clear )
				.border(vm.isValidReel ? .white : .gray, width: vm.isValidReel ? 0 : 1)
				
				
			}
			.padding([.leading,.trailing],10)
			.opacity(vm.isModalPresented ? 0 : 1)
		}
		.background(Color.black)
		.navigationBarHidden(true)
		.ignoresSafeArea(.keyboard, edges: [.bottom,.top])
		.enableLightStatusBar()
		.sheet(isPresented: $shoudldPickProduct, content: {
			ProductListView(linkedProducts: $vm.linkedProducts,completion: { vm.validateReel() })
		})
	}
}
