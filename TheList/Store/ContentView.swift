//
//  ContentView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
	@StateObject private var vm = ViewModel()
	init() {
		//		let navBarAppearance = UINavigationBar.appearance()
		//		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
		//		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
	}
	func loadImage(imageUrl: String) -> UIImage {
		var uiImage: UIImage?
		DocumentDirectory.getDocumentsDirectory().appendingPathComponent(imageUrl).loadImage(&uiImage)
		return uiImage!
	}
	var layout = [ GridItem(.flexible()),GridItem(.flexible())]
	var body: some View {
		NavigationView {
			VStack {
				VStack {
					Spacer()
					Text("Milan")
					Spacer()
					HStack (spacing: 0 ){
						Button(action: {
							vm.setFeedActive()
						}, label: {
							Text(StringConstants.MY_FEED)
								.font(.system(size: 18))
								.fontWeight(.bold)
								.frame(maxWidth: .infinity, maxHeight: 70)
								.overlay(
									Rectangle()
										.frame(height: 1)
										.foregroundColor(vm.isFeedActive ? .black: .gray),
									alignment: .bottom
								)
						}).tint(vm.isFeedActive ? .black : .gray)
						
						Button(action: {
							vm.setProductActive()
						}, label:{
							Text(StringConstants.MY_PRODUCTS)
								.font(.system(size: 18))
								.fontWeight(.bold)
								.frame(maxWidth: .infinity, maxHeight: 70)
								.overlay(
									Rectangle()
										.frame(height: 1)
										.foregroundColor(vm.isFeedActive ? .gray: .black),
									alignment: .bottom
								)
						}).tint(vm.isFeedActive ? .gray : .black)
					}
				}
				Spacer()
				VStack {
					Spacer()
					ZStack{
						if vm.hasCollection {
							ScrollView(.vertical) {
								LazyVGrid (columns: layout){
									ForEach(vm.reels, id: \.self) { item in
										Image(uiImage: loadImage(imageUrl: item.imageUrl!))
											.resizable()
											.aspectRatio(contentMode: .fill)
											.background(.clear)
									}
								}
							}.opacity(vm.isFeedActive ? 1 : 0)
						} else {
							VStack{
								Text(StringConstants.EMPTY_FEE_PLACEHOLDER_TEXT_1)
									.font(.system(size: 16))
									.fontWeight(.bold)
									.foregroundColor(Color.gray)
								Text(StringConstants.EMPTY_FEE_PLACEHOLDER_TEXT_2)
									.font(.system(size: 14))
									.fontWeight(.regular)
									.foregroundColor(Color.gray)
									.padding([.top],5)
									.padding([.leading, .trailing])
							}.opacity(vm.isFeedActive ? 1 : 0)
						}
						VStack {
							Spacer()
							HStack(){
								Spacer()
								Button(action: {}, label: {Image(ImageResources.HOME)}).padding()
								Button(action: {}, label: {Image(ImageResources.HANGER)}).padding()
								Button(action: {}, label: {Image(ImageResources.SHUTTER)}).padding()
								Button(action: {}, label: {Image(ImageResources.REQUEST)}).padding()
								Button(action: {}, label: {Image(ImageResources.REQUEST)}).padding()
								Spacer()
							}
							.background(Color.gray)
							.cornerRadius(45)
							.padding()
						}
					}
				}
			}
			.background(Color.white)
			.navigationTitle(StringConstants.STORE)
			.preferredColorScheme(.light)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading){
					NavButton(image: ImageResources.SETTINGS, action: {
					})
				}
				ToolbarItem(){
					NavButton(image: ImageResources.INBOX,action:{
					})
				}
				ToolbarItem(placement: .navigationBarTrailing){
					NavigationLink(destination: CameraView(),isActive: $vm.isCameraViewPresented) {
						NavButton(image: ImageResources.VIDEO,action: {
							vm.showCamera()
						})
					}
				}
			}
		}
		.enableDarkStatusBar()
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
