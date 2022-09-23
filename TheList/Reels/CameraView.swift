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
		VStack{
			ZStack{
				ReelCameraViewController(cameraService: cameraService, didFinishProcessingPhoto: {result in
					vm.saveCapturedPhoto(result)
				})
				VStack{
					HStack{
						Spacer()
						FloatingButton(image: ImageResources.CLOSE,tapAction: {
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
						NavigationLink(destination: EditReelView(capturedPhoto: $vm.capturedPhoto),isActive: $vm.isEditting){EmptyView()}
						Button(action: {
							cameraService.capturePhoto(with: vm.getCameraSetting())
						}, label: {
							Image(ImageResources.SHUTTER).resizable().aspectRatio(contentMode: .fill)
						})
						.frame(width: 90, height: 90)
						Spacer();
						FloatingButton(image: ImageResources.SWITCH,tapAction: {
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

			HStack(alignment: .center){
				NavButton(image: ImageResources.ADD_PHOTO,action: {}).padding(.leading,20)
				Spacer()
				Text(StringConstants.CAMERA_INSTRUCTION_2)
					.font(.system(size: 14))
					.fontWeight(.regular)
					.multilineTextAlignment(.trailing)
					.padding([.trailing],20)
					.foregroundColor(.white)
					.frame(width: 200)
			}
			
		}
		.background(.black)
		.navigationBarHidden(true)
		.enableLightStatusBar()
	}
}
