//
//  EditReelView-ViewModel.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 21/09/2022.
//

import Foundation
import UIKit

extension EditReelView {
	@MainActor class ViewModel : ObservableObject {
		
		@Published private(set) var isValidReel = false;
		@Published private(set) var inPreview = false;
		@Published var isModalPresented = false;
		@Published var reel: Reel = Reel()
		
		func viewPreview() { inPreview.toggle()}
		
		func presentModal(){ isModalPresented = true }
	}
}
