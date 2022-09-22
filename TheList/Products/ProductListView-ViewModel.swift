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
		@Environment(\.managedObjectContext) var dbContext
		@Published var products = [Product]()
		@Published var filteredProduct = [Product]()
		
		
		func getProducts() async {
			let entities = getAllProducts()
			if entities.count == 0 {
				await loadProduct();
			}else{
				products = getProductsFromDatabase(entities)
				filteredProduct = products
			}
		}
		
		func getAllProducts() -> [ProductData] {
			do {
				let fetchRequest = NSFetchRequest<ProductData>(entityName: "ProductData")
				let products = try dbContext.fetch(fetchRequest)
				return products
			} catch {
				print("Failed to fetch products: \(error)")
				return []
			}
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
		func createProducts(dtos: [ProductDto]) -> [Product] {
			return dtos.map({ dto in
				let product = Product(id: UUID(),selected: false,designer: dto.designer, title: dto.title, imageUrl: dto.imageUrl)
				let entity = ProductData(context: dbContext)
				entity.id = product.id
				entity.designer = product.designer
				entity.title = product.title
				entity.imageUrl = product.imageUrl
				try? dbContext.save()
				return product
			})
		}
		
		func getProductsFromDatabase (_ entities: [ProductData]) -> [Product] {
			
			return entities.map({ entity in
				return Product(id: entity.id!,selected: false,designer: entity.designer!,title: entity.title!,imageUrl: entity.imageUrl!)
			})
		}
	}
	
}
