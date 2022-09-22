//
//  EditReelView-ViewModel.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import UIKit
import SwiftUI

extension EditReelView {
	@MainActor class ViewModel : ObservableObject {
		
		@Published private(set) var isValidReel = false
		@Published private(set) var inPreview = false
		@Published var isModalPresented = false
		@Published var linkedProducts = [ProductData]()
		@Published var reel: Reel = Reel()
		
		func viewPreview() { inPreview.toggle()}
		
		func presentModal(){ isModalPresented = true }
		
		func validateReel() {
			isValidReel =  linkedProducts.count > 0 && reel.description != ""
			print("Validate Reel complete")
		}
		
		func saveReel(photo: Binding<UIImage?>, completion: @escaping ()->()){
			let image: UIImage = photo.wrappedValue!
			
			var reelEntity = Reel(id: UUID(), description: reel.description)
			
			if let data = image.jpegData(compressionQuality: 0.8) {
				let filePath = getDocumentsDirectory().appendingPathComponent("\(Date()).png")
				try? data.write(to: filePath)
				reelEntity.imageUrl = filePath.absoluteString
			}
			Repository.shared.createReel(reelEntity)
			print("Saved Reel")
			
			// Create linked product for give reel/post
			for linkedProduct in linkedProducts {
				Repository.shared.createLinkedProduct(reelId: reelEntity.id!, productId: linkedProduct.id)
			}
		}
		
		func getDocumentsDirectory() -> URL {
			let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
			return paths[0]
		}
	}
}
