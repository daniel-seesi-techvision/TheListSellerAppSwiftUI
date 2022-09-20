//
//  CameraView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI

struct CameraView : View {
	@Environment(\.dismiss) var dismiss
	@StateObject private var vm = ViewModel()
	var cameraService = CameraService()
	var body: some View {
		ZStack{
			ReelCameraViewController(cameraService: cameraService, didFinishProcessingPhoto: {result in
				vm.saveCapturedPhoto(result)
			})
			VStack{
				HStack{
					Spacer()
					FloatingButton(image: "close",tapAction: {
						dismiss()
					})
					.padding([.trailing,.top])
				}
				Spacer()
				HStack(alignment: .center){
					FloatingButton(image: vm.flashImage, tapAction: {
						vm.toggleFlashMode()
					})
					Spacer();
					Button(action: {
						cameraService.capturePhoto(with: vm.getCameraSetting())
					}, label: {
						Image("shutter").resizable().aspectRatio(contentMode: .fill)
					})
					.frame(width: 90, height: 90)
					Spacer();
					FloatingButton(image: "switch",tapAction: {
						cameraService.switchCamera(completion: { ex in
							vm.handleError(err: ex)
						})
					})
				}
				.padding([.leading,.trailing],60)
				.padding(.bottom,20)
				
			}
		}
		.preferredColorScheme(.dark)
		.cornerRadius(10)
		.padding([.top], 10)
		.padding([.bottom], 90)
		.background(Color.black)
		.navigationBarHidden(true)
	}
}
