//
//  Repository.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 22/09/2022.
//
import CoreData
import Foundation
import SQLite

class Repository {
	
	static let shared = Repository()
		
	static let DIR_APP_DB = "AppDB"
	static let STORE_NAME = "App.sqlite3"
	static let PRODUCT_TABLE_NAME = "Products"
	private let productTable = Table(PRODUCT_TABLE_NAME)
	
	private let id = Expression<Int>("id")
	private let desinger = Expression<String>("designer")
	private let title = Expression<String>("title")
	private let imageUrl = Expression<String>("imageUrl")

	
	private var db: Connection? = nil
	
	private init() {
		if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
			let dirPath = docDir.appendingPathComponent(Self.DIR_APP_DB)
			
			do {
				try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
				let dbPath = dirPath.appendingPathComponent(Self.STORE_NAME).path
				db = try Connection(dbPath)
				createTable()
				print("SQLiteDataStore init successfully at: \(dbPath) ")
			} catch {
				db = nil
				print("SQLiteDataStore init error: \(error)")
			}
		} else {
			db = nil
		}
	}
	
	private func createTable() {
		guard let database = db else {
			return
		}
		do {
			try database.run(productTable.create { table in
				table.column(id, primaryKey: .autoincrement)
				table.column(desinger)
				table.column(title)
				table.column(imageUrl)
			})
			print("Table Created...")
		} catch {
			print(error)
		}
	}
	
	func getAllProducts() -> [Product] {
		var tasks: [Product] = []

		guard let database = db else { return [] }
		
		do {
			for task in try database.prepare(self.productTable) {
				tasks.append(Product(id: task[id], designer: task[desinger], title: task[title], imageUrl: task[imageUrl]))
			}
		} catch {
			print(error)
		}
		return tasks
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

}
