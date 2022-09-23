//
//  MainNavigationView.swift
//  TheList
//
//  Created by Daniel Adoboah-Seesi on 23/09/2022.
//

import SwiftUI

struct MainNavigationView: View {
	@EnvironmentObject var appState: AppState
	@State var isRootView: Bool = true

    var body: some View {
		 NavigationView {
			 NavigationLink(destination: ContentView(), isActive: $isRootView){
				 ContentView()
			 }
		 }		 
		 .onReceive(self.appState.$moveToStore){ moveToStore in
			 if moveToStore {
				 self.isRootView = false
				 self.appState.moveToStore = false
			 }
		 }
    }
}


