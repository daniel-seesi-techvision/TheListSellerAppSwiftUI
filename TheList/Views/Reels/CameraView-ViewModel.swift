//
//  CameraView-ViewModel.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import Foundation
import AVFoundation
import UIKit

extension CameraView{
	@MainActor class ViewModel : ObservableObject {
		
		@Published private(set) var flashMode = AVCaptureDevice.FlashMode.off
		@Published private(set) var flashImage = "flash-off"
		private var capturedPhoto: UIImage? = nil
		
		func toggleFlashMode(){
			switch flashMode {
				case .off:
					flashMode = .on
					flashImage = "flash-on"
				case .on:
					flashMode = .auto
					flashImage = "flash-auto"
				case .auto:
					flashMode = .off
					flashImage = "flash-off"
				@unknown default:
					flashMode = .on
					flashImage = "flash-on"
			}
		}
		
		func getCameraSetting() -> AVCapturePhotoSettings {
			let settings = AVCapturePhotoSettings();
			settings.flashMode = flashMode;
			return settings;
		}
		
		func saveCapturedPhoto(_ result: Result<AVCapturePhoto,Error> ) {
			switch result{
				case .success(let photo):
					if let data = photo.fileDataRepresentation(){
						capturedPhoto = UIImage(data: data)
					}else{
						print("Error: No image data found")
						//TODO Alert User Friendley message
					}
				case .failure(let err):
					print(err.localizedDescription)
					//TODO Alert User Friendley message
			}
		}
		
		func handleError(err: Error?){
			if err != nil {
				// Alert User Friendly Error
			}
			
		}
	}
}
