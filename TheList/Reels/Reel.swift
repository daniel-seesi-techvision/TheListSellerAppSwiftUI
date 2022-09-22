//
//  Reel.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
struct Reel : Identifiable, Hashable {
	var id: UUID? = nil
	var imageUrl: String? = nil
	var description: String = ""
}
