//
//  TheListApp.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI

@main
struct TheListApp: App {
	let repository = Repository.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
				  .environment(\.managedObjectContext, repository.database.viewContext)
        }
    }
}
