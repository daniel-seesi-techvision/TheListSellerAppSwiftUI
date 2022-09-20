//
//  ContentView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI
import CoreData

struct ContentView: View {
	@State private var capturedPhoto: UIImage? = nil
	@State private var isCameraViewPresented = false;
	@State private var isFeedActive = true
	@State private var hasCollection = false;
	init() {
		//		let navBarAppearance = UINavigationBar.appearance()
		//		navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
		//		navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
	}
	var body: some View {
		NavigationView {
			VStack{
				Spacer()
				Text("Test Middle")
				Spacer()
				HStack (spacing: 0 ){
					Button(action: {
						isFeedActive = true
					}, label: {
						Text("MY FEED")
							.font(.system(size: 18))
							.fontWeight(.bold)
							.frame(maxWidth: .infinity, maxHeight: 70)
							.overlay(
								Rectangle()
									.frame(height: 1)
									.foregroundColor(isFeedActive ? .black: .gray),
								alignment: .bottom
							)
					}).tint(isFeedActive ? .black : .gray)
					
					Button(action: {
						isFeedActive = false;
					}, label:{
						Text("MY PRODUCTS")
							.font(.system(size: 18))
							.fontWeight(.bold)
							.frame(maxWidth: .infinity, maxHeight: 70)
							.overlay(
								Rectangle()
									.frame(height: 1)
									.foregroundColor(isFeedActive ? .gray: .black),
								alignment: .bottom
							)
					}).tint(isFeedActive ? .gray : .black)
				}
				Spacer()
				if(isFeedActive){
					if(hasCollection){
						// Setup collectionview
					}else{
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
						}
					}
				}else{
					
				}
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
					NavigationLink(destination: CameraView(capturedPhoto: $capturedPhoto),isActive: $isCameraViewPresented) {
						NavButton(image: "video",action: {
							self.isCameraViewPresented = true;
						})
					}
				}
			}
			//			.background(Color.white)
		}
	}
	
	private func addItem() {
	}
}


struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
