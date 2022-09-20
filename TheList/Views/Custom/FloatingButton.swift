//
//  FloatingButton.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI

struct FloatingButton: View {
    var image: String
    var tapAction: (() -> Void)? = nil
    
    private func defaultAction(){
        //        do nothing;
    }
    var body: some View {
		 Button(action: tapAction ?? defaultAction ) {
			 Image(image)
				 .resizable()
				 .frame(width: 25, height: 25, alignment: .center)
				 .aspectRatio(contentMode: .fill)
		 }
		 .frame(width: 50, height: 50, alignment: .center)
		 .background(
			Color(UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5))
		 )
		 .cornerRadius(25)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(image: "settings")
    }
}
