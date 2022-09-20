//
//  NavButton.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 20/09/2022.
//

import SwiftUI

struct NavButton: View {
	
   var image: String
	var action : () -> ()
    
    var body: some View {
		 Button(action: action, label: {
			 Image(image)
				 .aspectRatio(contentMode: .fill)
				 .tint(.black)
		 })
    }
}


struct NavButton_Previews: PreviewProvider {
    static var previews: some View {

		 NavButton(image: "setting",action: {})
    }
}
