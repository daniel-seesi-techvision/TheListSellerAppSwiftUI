//
//  MissionControlButton.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI

struct MissionControlButton: View {
    var image: String
    var heightFraction: CGFloat?
    var tapAction: (() -> Void)? = nil
    
    private func defaultAction(){
        //        do nothing;
    }
    var body: some View {
        GeometryReader { metrics in
            Button(action: tapAction ?? defaultAction ) {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
//            .frame(
//                width: metrics.size.height * (heightFraction ?? 0.5),
//                height: metrics.size.height * (heightFraction ?? 0.5),
//                alignment: .center
//            )
            .background(
                Color(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.0))
            )
        }
    }
}

struct MissionControlButton_Previews: PreviewProvider {
    static var previews: some View {
        MissionControlButton(image: "settings")
            .previewInterfaceOrientation(.portrait)
    }
}
