//
//  FileManagerExtension.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 23/09/2022.
//

import Foundation

class DocumentDirectory {
	static func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}

class AppState : ObservableObject {
	static let shared = AppState()
	@Published var moveToStore: Bool  = false
}
