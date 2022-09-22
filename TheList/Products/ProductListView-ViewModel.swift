//
//  ProductListView-ViewModel.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import SwiftUI
import CoreData

extension ProductListView{
	
	@MainActor class ViewModel : ObservableObject {
		@Published var products = [ProductData]()
		@Published var filteredProduct = [ProductData]()
				
		func getProducts() async {
			let entities = getAllProducts()
			if entities.count == 0 {
				await loadProduct();
			}else{
				products = getProductsFromDatabase(entities)
				filteredProduct = products
			}
		}
		
		func getAllProducts() -> [Product] {
			return Repository.shared.getAllProducts()
		}
		
		// TODO persist to database
		func loadProduct() async {
			guard let url = URL(string: API.BASE_URL) else{
				print("Invalid URL")
				return;
			}
			
			do {
				let (data, _) = try await URLSession.shared.data(from: url)
				// Serialize data into object
				if let response = try? JSONDecoder().decode([ProductDto].self, from: data){
					products = createProducts(dtos: response)
					filteredProduct = products
					print("Fetch Success:")
				}else{
					print("Serialization failed:")
				}
			}catch{
				print("Invalid Data")
			}
		}
		
		// MARK: TODO Use Generic functions in the future
		func createProducts(dtos: [ProductDto]) -> [ProductData] {
			var count = 0
			return dtos.map({ dto in
				count += 1;
				let product = ProductData(id: count,selected: false,designer: dto.designer, title: dto.title, imageUrl: dto.imageUrl)
				Repository.shared.createProduct(product)
				return product
			})
		}
		
		func getProductsFromDatabase (_ entities: [Product]) -> [ProductData] {
			return entities.map({ entity in
				return ProductData(id: entity.id,selected: false,designer: entity.designer,title: entity.title,imageUrl: entity.imageUrl)
			})
		}
		
		func filterProduct(_ search: String){
			if(search == ""){
				filteredProduct = products
				return
			}
			var array = [ProductData]()
			for product in products {
				let searchString = search.lowercased()
				let designer = product.designer.lowercased()
				let title = product.title.lowercased()
				if designer.contains(searchString) || title.contains(searchString){
					array.append(product)
					
				}
			}
			filteredProduct = array
		}
	}
	
}
