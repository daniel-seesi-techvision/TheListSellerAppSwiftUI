//
//  Repository.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 22/09/2022.
//
import CoreData
import Foundation


class Repository {
	
	static let shared = Repository()
	
	let database = NSPersistentContainer(name: "TheList")
	
	init(){
		database.loadPersistentStores(completionHandler: {descrption, error in
			if let error = error {
				print("Could not load database with reason \(error.localizedDescription)")
			}
		})
	}
	
	func save(completion: @escaping (Error?) -> () = {_ in}){
		let context = database.viewContext
		if context.hasChanges {
			do {
				try context.save()
				completion(nil)
			}catch{
				completion(error)
			}
		}
	}
	
	func delete(_ object: NSManagedObject, completion: @escaping (Error?) -> () = {_ in}){
		let context = database.viewContext
		context.delete(object)
		save(completion: completion)
	}
}
