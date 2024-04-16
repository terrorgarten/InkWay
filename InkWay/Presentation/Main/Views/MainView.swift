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
        // only if the user logged and we have his id
        if viewModel.signedIn, !viewModel.currentUserId.isEmpty {
            TabView {
                // only if user is status
                if viewModel.currentUserArtistStatus {
                    UploadDesignView()
                        .tabItem {
                            Label("Upload", systemImage: "square.and.arrow.up.circle.fill")
                        }
                    
                    UserDesignView(userId: viewModel.currentUserId)
                        .tabItem {
                            Label("My designs", systemImage: "photo.stack")
                        }
                }
                
                FindArtistsView()
                    .tabItem {
                        Label("Find", systemImage: "mappin.and.ellipse")
                    }
                    
                UserProfileView(viewModel: viewModel.userProfileViewModel)
                    .tabItem {
                        Label("Me", systemImage: "person.circle")
                    }
            }
        } else {
            // user isnt logged in, send him there
            LoginView()
        }
    }
    
}
