//
//  HomeView.swift
//  InkWay
//
//  Created by Oliver Bajus on 16.04.2024.
//

import Foundation

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    @ObservedObject var userViewModel: UserProfileViewModel
    @EnvironmentObject var router: BaseRouter
    
    init(currentUserId: String, currentUserArtistStatus: Bool, userViewModel: UserProfileViewModel) {
        self.viewModel = HomeViewModel(currentUserId: currentUserId, currentUserArtistStatus: currentUserArtistStatus)
        self.userViewModel = userViewModel
    }
    
    var body: some View {
        TabView {
            // only if user is status
            if viewModel.currentUserArtistStatus {
                UserDesignView(userId: viewModel.currentUserId)
                    .tabItem {
                        Label("My designs", systemImage: "photo.stack")
                    }
            }
            
            UserFeedView()
                .tabItem {
                    Label("Feed", systemImage: "mappin.and.ellipse")
                }
            
            UserProfileView(viewModel: userViewModel)
                .tabItem {
                    Label("My profile", systemImage: "person.circle")
                }
        }
    }
}
