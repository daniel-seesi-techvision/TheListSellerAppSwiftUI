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
		@Published private(set) var flashImage = ImageResources.FLASH_OFF
		@Published var isEditting = false;
		@Published var capturedPhoto: UIImage? = nil
		
		func toggleFlashMode(){
			switch flashMode {
				case .off:
					flashMode = .on
					flashImage = ImageResources.FLASH_ON
				case .on:
					flashMode = .auto
					flashImage = ImageResources.FLASH_AUTO
				case .auto:
					flashMode = .off
					flashImage = ImageResources.FLASH_OFF
				@unknown default:
					flashMode = .on
					flashImage = ImageResources.FLASH_ON
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
						isEditting = true
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
