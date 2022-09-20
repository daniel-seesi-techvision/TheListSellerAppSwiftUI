//
//  CameraService.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import Foundation
import AVFoundation

class CameraService{
	var session: AVCaptureSession?
	var delegate: AVCapturePhotoCaptureDelegate?
	
	let output = AVCapturePhotoOutput()
	let previewCameraLayer = AVCaptureVideoPreviewLayer()
	
	func startSession(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()){
		self.delegate = delegate;
		checkPermission(completion: completion)
	}
	
	private func checkPermission(completion: @escaping (Error?) -> ()){
		switch AVCaptureDevice.authorizationStatus(for: .video){
			case .notDetermined:
				// Ask for permission
				AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] granted in
					guard granted else {return }
					DispatchQueue.main.async {
						self?.setupCamera(completion: completion)
					}
				})
			case .restricted:
				break
			case .denied:
				break
			case .authorized:
				setupCamera(completion: completion)
			@unknown default:
				break
		}
	}
	
	private func setupCamera(completion: @escaping (Error?) -> ()){
		let session = AVCaptureSession();
		if let device = AVCaptureDevice.default(for: .video){
			do {
				let input = try AVCaptureDeviceInput(device: device)
				if session.canAddInput(input){
					session.addInput(input)
				}
				if session.canAddOutput(output){
					session.addOutput(output)
				}
				previewCameraLayer.videoGravity = .resizeAspectFill
				previewCameraLayer.session = session;
				session.startRunning()
				self.session = session;
			} catch {
				completion(error)
			}
		}
	}
	
	func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()){
		output.capturePhoto(with: settings, delegate: delegate!)
	}
}
