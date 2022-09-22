//
//  Reel.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
struct Reel : Identifiable {
	var id: Int? = nil
	var imageUrl: String? = nil
	var description: String = ""
	var linkedProduct: [LinkedProduct] = [LinkedProduct()]
}
