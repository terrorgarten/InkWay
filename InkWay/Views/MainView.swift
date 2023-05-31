//
//  ContentView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.signedIn, !viewModel.currentUserId.isEmpty {
            // user is signed in
            TabView {
                UserHomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                UserProfileView()
                    .tabItem {
                        Label("Me", systemImage: "person.circle")
                    }
                LocationTestView()
                    .tabItem{
                        Label("Map", systemImage: "mappin.and.ellipse")
                    }
            }
        } else {
            // not signed in, send users to registration
            LoginView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
