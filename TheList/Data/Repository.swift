//
//  Repository.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 22/09/2022.
//
import CoreData
import Foundation
import SQLite

// I had issues seting up CoreData. --> Will move to CoreData in the future.
class Repository {
	
	static let shared = Repository()
	
	private let productTable = Table(DataConstants.PRODUCT_TABLE_NAME)
	private let productTableId = Expression<Int>("id")
	private let desinger = Expression<String>("designer")
	private let title = Expression<String>("title")
	private let imageUrl = Expression<String>("imageUrl")
	
	
	private let reelProductTable = Table(DataConstants.REEL_LINKPRODUCT_TABLE_NAME)
	private let reelProductTableId = Expression<Int>("id")
	private let reelId = Expression<UUID>("reelId")
	private let productId = Expression<Int>("productId")
	
	
	private let reelTable = Table(DataConstants.REEL_TABLE_NAME)
	private let reelTableId = Expression<UUID>("id")
	private let description = Expression<String>("description")
	private let reelImage = Expression<String>("reelImage")

	
	private var db: Connection? = nil
	
	private init() {
		if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let dirPath = docDir.appendingPathComponent(DataConstants.DIR_APP_DB)
			
			do {
				try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
				let dbPath = dirPath.appendingPathComponent(DataConstants.STORE_NAME).path
				db = try Connection(dbPath)
				createProductTable()
				createReelProductTable()
				createReelTable()
				print("SQLiteDataStore init successfully at: \(dbPath) ")
			} catch {
				db = nil
				print("SQLiteDataStore init error: \(error)")
			}
		} else {
			db = nil
		}
	}
	
	private func createProductTable() {
		guard let database = db else {
			return
		}
		do {
			try database.run(productTable.create { table in
				table.column(productTableId, primaryKey: .autoincrement)
				table.column(desinger)
				table.column(title)
				table.column(imageUrl)
			})
		} catch {
			print(error)
		}
	}
	
	func getAllProducts() -> [Product] {
		var products: [Product] = []

		guard let database = db else { return [] }
		
		do {
			for task in try database.prepare(self.productTable) {
				products.append(Product(id: task[productTableId], designer: task[desinger], title: task[title], imageUrl: task[imageUrl]))
			}
		} catch {
			print(error)
		}
		return products
	}
	
	func createProduct(_ product: ProductData) {
		guard let database = db else { return  }
		
		let insert = productTable.insert(
			self.desinger <- product.designer,
			self.imageUrl <- product.imageUrl,
			self.title <- product.title)
		do {
			_ = try database.run(insert)
		} catch {
			print("Error saving product \(error)")
			return
		}
	}
	
		
	private func createReelProductTable(){
		guard let database = db else {
			return
		}
		do {
			try database.run(reelProductTable.create { table in
				table.column(reelProductTableId, primaryKey: .autoincrement)
				table.column(reelId)
				table.column(productId)
			})
		} catch {
			print(error)
		}
	}
	
	func getLinkedProducts(targeReelId: UUID) -> [Product]{
		var products: [Product] = []
		
		guard let database = db else { return [] }
		
		do {
			// Get linked product for a reel
			for linkedProducts in try database.prepare(self.reelProductTable).filter({ row in
				return row[reelId] == targeReelId
			}) {
				// Get Product entity from data base
				guard let product = try database.prepare(self.productTable).first(where: { row in
					return row[productTableId] == linkedProducts[productId]
				}) else{
					continue
				}
				products.append(Product(id: product[productTableId], designer: product[desinger], title: product[title], imageUrl: product[imageUrl]))
			}
		} catch {
			print(error)
		}
		return products
	}
	
	func createLinkedProduct(reelId: UUID, productId: Int) {
		guard let database = db else { return  }
		
		let insert = reelProductTable.insert(
			self.reelId <- reelId,
			self.productId <- productId)
		do {
			_ = try database.run(insert)
		} catch {
			print("Error saving linked product \(error)")
			return
		}
	}
	
	
	private func createReelTable(){
		guard let database = db else {
			return
		}
		do {
			try database.run(reelTable.create { table in
				table.column(reelTableId)
				table.column(reelImage)
				table.column(description)
			})
		} catch {
			print(error)
		}
	}
	
	func getAllReels() -> [Reel]{
		var reels: [Reel] = []
		
		guard let database = db else { return [] }
		
		do {
			for reel in try database.prepare(self.reelTable) {
				reels.append(Reel(id: reel[reelTableId], imageUrl: reel[reelImage], description: reel[description]))
			}
		} catch {
			print(error)
		}
		return reels
	}
	
	func createReel(_ reel: Reel) {
		guard let database = db else { return  }
		
		let insert = reelTable.insert(
			self.reelTableId <- reel.id!,
			self.description <- reel.description,
			self.reelImage <- reel.imageUrl ?? "")
		do {
			_ = try database.run(insert)
		} catch {
			print("Error saving reel \(error)")
			return
		}
	}

}
