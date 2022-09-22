//
//  ContentView-ViewModel.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import Foundation
import UIKit

extension ContentView{
	@MainActor class ViewModel: ObservableObject {
		@Published var capturedPhoto: UIImage? = nil
		@Published var isCameraViewPresented = false;
		@Published private(set) var isFeedActive = true
		@Published private(set) var hasCollection = false;
		@Published private(set) var reels = [Reel]()
		init(){
			reels = Repository.shared.getAllReels()
		}
		func setFeedActive() {
			isFeedActive = true
		}
		
		func setProductActive(){
			isFeedActive = false;
		}
		
		func showCamera(){
			isCameraViewPresented = true;
		}
	}
}
