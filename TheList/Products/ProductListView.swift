//
//  ProductListView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import SwiftUI

struct ProductListView: View {
	@Environment(\.dismiss) var dismiss
	@Binding var linkedProducts: [ProductData]
	var completion: ()-> Void
	@StateObject private var vm = ViewModel()
	@State private var searchText = ""
	
	func saveLinkedProducts(){
		linkedProducts = self.vm.products.filter({product in
			return product.selected
		})
		completion()
	}
													
	var body: some View {
		VStack{
			ZStack (alignment: .center){
				Text(StringConstants.PRODUCT_LIST_INSTRUCTION_1)
					.foregroundColor(.black)
					.font(.system(size: 16))
					.fontWeight(.bold)
				HStack{
					Spacer()
					Button(action: {
						saveLinkedProducts()
						dismiss()
					},label: {
						Image(ImageResources.BLACK_CLOSED)
					})
					.background(.clear)
					.padding([.trailing])
				}
			}.padding()
			HStack{
				TextField(StringConstants.SEARCH_PRODUCT_PLACEHOLDER, text: $searchText).onChange(of: $searchText.wrappedValue, perform: {newValue in
					vm.filterProduct(newValue)
				})
				.accentColor(.black)
				.frame(height: 50)
				.padding([.leading,.trailing],10)
				.font(.system(size: 14))
			}
			.background(Color(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.05)))
			.padding([.leading,.trailing],20)
			.cornerRadius(3)
			
			List(vm.filteredProducts, id: \.id){ item in
				VStack(alignment: .leading){
					HStack{
						AsyncImage(url: URL(string: item.imageUrl)) { image in
							image
								.resizable()
								.aspectRatio(contentMode: .fit)
								.background(.clear)
						} placeholder: {
							ProgressView()
						}
						.frame(width: 70, height: 70)
						.background(Color(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.03)))
						.padding()
						VStack(alignment:.leading){
							Text(item.designer)
								.font(.system(size: 14))
								.fontWeight(.bold)
							Text(item.title)
								.font(.system(size: 12))
						}
						Spacer()
						CheckBoxButton(checked: $vm.products.first(where: {product in
							return product.id == item.id
						})!.selected)
					}
				}
			}
			.task {
				await vm.getProducts()
				vm.setSelectedProducts($linkedProducts)
			}.onTapGesture {
				UIApplication.shared.endEditing()
			}
			HStack{
				Button(action: {
					saveLinkedProducts()
					dismiss()
				}, label: {
					Text(StringConstants.SAVE_SELECTION)
						.foregroundColor(.white)
						.font(.system(size: 16))
						.fontWeight(.bold)
				})
				
			}
			.frame(maxWidth: .infinity, maxHeight: 50, alignment: .center)
			.background(.black)
			.padding(20)
			.cornerRadius(5)
		}.background(.white)
	}
}
