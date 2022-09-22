//
//  CameraService.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import Foundation
import AVFoundation
import UIKit

class CameraService {
	
	var parentView: UIView? = nil
	var session: AVCaptureSession?
	var delegate: AVCapturePhotoCaptureDelegate?
	var input: AVCaptureDeviceInput? = nil
	var output: AVCapturePhotoOutput? = nil
	var previewCameraLayer: AVCaptureVideoPreviewLayer? = nil
		
	let videoDeviceDiscoverySession:	AVCaptureDevice.DiscoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [.builtInWideAngleCamera,.builtInDualCamera], mediaType: .video, position: .unspecified)
	
	func startSession(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()){
		self.delegate = delegate
		checkPermission(completion: completion)
	}
	
	private func checkPermission(completion: @escaping (Error?) -> ()){
		switch AVCaptureDevice.authorizationStatus(for: .video){
			case .notDetermined:
				// Ask for permission
				AVCaptureDevice.requestAccess(for: .video, completionHandler: {[weak self] granted in
					guard granted else {return }
					DispatchQueue.main.async {
						self?.initCamera(.back,completion: completion)
					}
				})
			case .restricted:
				break
			case .denied:
				break
			case .authorized:
				initCamera(.back,completion: completion)
			@unknown default:
				break
		}
	}
	
	private func initCamera(_ preferredPosition: AVCaptureDevice.Position,completion: @escaping (Error?) -> ()){
		var preferredDeviceType = AVCaptureDevice.DeviceType.builtInDualCamera
		switch preferredPosition {
			case .unspecified:
				break; //TODO Log event
			case .front:
				preferredDeviceType = .builtInWideAngleCamera
			case .back:
				preferredDeviceType = .builtInDualCamera
			default:
				break
		}
		self.setupCameraSession(preferredPosition,preferredDeviceType, completion: completion)
	}
	
	func switchCamera(completion: @escaping (Error?) -> ()){
		
		if let currentVideoDevice = input?.device {
			let currentPosition = currentVideoDevice.position
			var preferredPosition = AVCaptureDevice.Position.unspecified
			var preferredDeviceType = AVCaptureDevice.DeviceType.builtInWideAngleCamera
			
			switch currentPosition {
				case .unspecified:
					break
				case .front:
					preferredPosition = .back
					preferredDeviceType = .builtInDualCamera
				case .back:
					preferredPosition = .front
					preferredDeviceType = .builtInWideAngleCamera
				@unknown default:
					preferredPosition = .back
					preferredDeviceType = .builtInDualCamera
			}
			setupCameraSession(preferredPosition,preferredDeviceType,completion: completion)
		}
	}
	
	private func setupCameraSession(_ preferredPosition: AVCaptureDevice.Position,_ deviceType: AVCaptureDevice.DeviceType,	completion: @escaping (Error?) -> ()){
			
			let devices = videoDeviceDiscoverySession.devices
			var newDevice: AVCaptureDevice? = nil
			
			// First, look for a devices with both the preferred postion and device type.
			for dev in devices{
				if dev.position == preferredPosition && dev.deviceType.rawValue == deviceType.rawValue{
					newDevice = dev
					break
				}
			}
			
			// Otherwise, look for a devices with only the preferred position
			if newDevice == nil{
				for dev in devices{
					if dev.position == preferredPosition {
						newDevice = dev
						break
					}
				}
			}
			
			if newDevice == nil{
				return
			}
			
			let session = AVCaptureSession()
			
			// TODO Find a better way to check if layer is in sublayer
			let layerIsAlreadyInView = previewCameraLayer?.superlayer != nil
			if layerIsAlreadyInView{
				previewCameraLayer?.removeFromSuperlayer()
			}
			
			previewCameraLayer = AVCaptureVideoPreviewLayer(session: session)
			previewCameraLayer?.frame = parentView!.layer.bounds
			previewCameraLayer?.videoGravity = .resizeAspectFill
			
			parentView!.layer.addSublayer(previewCameraLayer!)
			
			if input != nil{
				session.removeInput(input!)
			}
			do {
				input = try AVCaptureDeviceInput(device: newDevice!)
				if session.canAddInput(input!){
					session.addInput(input!)
				}
				
				if output != nil{
					session.removeOutput(output!)
				}
				output = AVCapturePhotoOutput()
				if session.canAddOutput(output!){
					session.addOutput(output!)
				}
				
				previewCameraLayer!.session = session;
//				previewCameraLayer!.connection?.automaticallyAdjustsVideoMirroring = false
//				previewCameraLayer!.connection?.isVideoMirrored = true
				
				session.startRunning()
				
				self.session = session;
			} catch {
				completion(error)
			}
		}
	
	func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()){
		output!.capturePhoto(with: settings, delegate: delegate!)
	}
}
