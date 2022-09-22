//
//  Product.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
struct ProductDto: Codable {
	var designer: String
	var title: String
	var imageUrl: String
}

struct Product: Identifiable {
	var id: UUID
	var selected: Bool
	var designer: String
	var title: String
	var imageUrl: String
}
