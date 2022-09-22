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
	var body: some View {
		NavigationView {
			VStack {
				Spacer()
				Text("Milan")
				Spacer()
				HStack (spacing: 0 ){
					Button(action: {
						vm.setFeedActive()
					}, label: {
						Text("MY FEED")
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
						Text("MY PRODUCTS")
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
				Spacer()
				// Grid or LazyVGrid
				VStack{
					Text("Your Feed Is Still Empty")
						.font(.system(size: 16))
						.fontWeight(.bold)
						.foregroundColor(Color.gray)
					Text("Upload your content by tapping on \"+\" to promote your product and keep customer and visitors updated on new arrivals")
						.font(.system(size: 14))
						.fontWeight(.regular)
						.foregroundColor(Color.gray)
						.padding([.top],5)
						.padding([.leading, .trailing])
				}.opacity(!vm.hasCollection && vm.isFeedActive ? 1 : 0)
				Spacer()
				HStack(){
					Spacer()
					Button(action: {}, label: {Image("home")}).padding()
					Button(action: {}, label: {Image("hanger")}).padding()
					Button(action: {}, label: {Image("shutter")}).padding()
					Button(action: {}, label: {Image("request")}).padding()
					Button(action: {}, label: {Image("package")}).padding()
					Spacer()
				}
				.background(Color.gray)
				.cornerRadius(45)
				.padding()
			}
			.background(Color.white)
			.navigationTitle("Store")
			.preferredColorScheme(.light)
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .navigationBarLeading){
					NavButton(image: "settings",action: {
					})
				}
				ToolbarItem(){
					NavButton(image: "inbox",action:{
					})
				}
				ToolbarItem(placement: .navigationBarTrailing){
					NavigationLink(destination: CameraView(),isActive: $vm.isCameraViewPresented) {
						NavButton(image: "video",action: {
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
