//
//  CameraView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI

struct CameraView : View {
	var cameraService = CameraService()
	@Binding var capturedPhoto: UIImage?
	@Environment(\.dismiss) var dismiss
	var body: some View {
		ZStack{
			ReelCameraViewController(cameraService: cameraService, didFinishProcessingPhoto: {result in
				switch result{
						
					case .success(let photo):
						if let data = photo.fileDataRepresentation(){
							capturedPhoto = UIImage(data: data)
						}else{
							print("Error: No image data found")
						}
					case .failure(let err):
						print(err.localizedDescription)
				}
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
				Button(action: {
					cameraService.capturePhoto()
				}, label: {
					Image("shutter")
						.font(.system(size: 72))
				})
				.padding(.bottom)
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
