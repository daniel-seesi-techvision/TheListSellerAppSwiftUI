//
//  Product.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation

// Product dto from http response
struct ProductDto: Codable {
	var designer: String
	var title: String
	var imageUrl: String
}

// Product struct uses in Views
struct ProductData: Identifiable, Hashable {
	var id: Int
	var selected: Bool
	var designer: String
	var title: String
	var imageUrl: String
}

// Product entity saved in database
struct Product: Identifiable {
	var id: Int
	var designer: String
	var title: String
	var imageUrl: String
}
