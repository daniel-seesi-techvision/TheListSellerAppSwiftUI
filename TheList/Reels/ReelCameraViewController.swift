//
//  ReelCamera.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI
import AVFoundation;

struct ReelCameraViewController: UIViewControllerRepresentable {
	
	typealias UIViewControllerType = UIViewController
	
	let cameraService: CameraService
	let didFinishProcessingPhoto: (Result<AVCapturePhoto,Error>) -> ()
	
	func makeUIViewController(context: Context) -> UIViewController {
		let viewController = UIViewController()
		viewController.view.backgroundColor = .black
		
		cameraService.parentView = viewController.view
		
		cameraService.startSession(delegate: context.coordinator, completion: {err in
			if let err  = err {
				didFinishProcessingPhoto(.failure(err))
				return
			}
			cameraService.previewCameraLayer!.frame = viewController.view.bounds
		})
		return viewController;
	}
	
	func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
	}
	
	func makeCoordinator() -> Coordinator {
		Coordinator(self,didFinishProcessingPhoto: didFinishProcessingPhoto)
	}
	
	class Coordinator: NSObject, AVCapturePhotoCaptureDelegate{
		private var didFinishProcessingPhoto: (Result<AVCapturePhoto,Error>) -> ()
		
		let parent: ReelCameraViewController
		
		init(_ parent: ReelCameraViewController, didFinishProcessingPhoto: @escaping (Result<AVCapturePhoto,Error>) -> ()){
			self.parent = parent;
			self.didFinishProcessingPhoto = didFinishProcessingPhoto
		}
		
		func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
			if let error = error{
				didFinishProcessingPhoto(.failure(error))
				return
			}
			didFinishProcessingPhoto(.success(photo))
		}
	}
}
