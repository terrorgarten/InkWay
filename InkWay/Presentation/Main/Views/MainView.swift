//
//  ContentView.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import SwiftUI


// main view, shows the TabView and removes the artist only options on status updates
struct MainView: View {
    
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        VStack {
            if !viewModel.signedIn, viewModel.currentUserId.isEmpty {
                WelcomeView()
            } else {
                HomeView(currentUserId: viewModel.currentUserId, currentUserArtistStatus: viewModel.currentUserArtistStatus, userViewModel: viewModel.userProfileViewModel)
            }
        }
    }
}
