//
//  TheListApp.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI

@main
struct TheListApp: App {
	let appState = AppState.shared
    var body: some Scene {
        WindowGroup {
            MainNavigationView()
				  .environmentObject(appState)
        }
    }
}
