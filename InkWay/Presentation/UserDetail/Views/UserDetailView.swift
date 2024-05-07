//
//  UserDetailView.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation
import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var isFollowing: Bool = false
    
    var body: some View {
            ScrollView {
                if let designs = viewModel.posts {
                    VStack(alignment: .center) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                AsyncImage(url: viewModel.user.profilePictureURL){ image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 90, height: 90)
                                        .cornerRadius(100)
                                } placeholder: {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .frame(width: 90, height: 90)
                                }
                                .frame(height: 90)
                        
                            }
                            .padding(.top)
                            Spacer()
                            VStack(alignment: .center) {
                                if isFollowing {
                                    IWPrimaryButton(title: String(localized: "Unfollow"), color: Color.gray, action: {
                                        isFollowing = false
                                        viewModel.handleFollowAction(following: isFollowing)
                                    })
                                        .frame(maxWidth: 180)
                                } else {
                                    IWPrimaryButton(title: String(localized: "Follow"), color: Color.accentColor, action: {
                                        isFollowing = true
                                        viewModel.handleFollowAction(following: isFollowing)
                                    })
                                        .frame(maxWidth: 180)
                                }
                                Text("Followers: 32")
                                    .font(.system(.headline))
                            }
                        }
                        .padding(.horizontal)
                        Text("""
                            🔥 Passionate Tattoo Artist 🔥
                            🎨 Custom Designs | Fine Artistry | Professional Service
                            📸 Follow for Daily Ink Inspiration 📸
                            🎉 Bookings Open | DM for Appointments 🎉
                            #TattooArtist #InkLife #TattooInspiration
                            """)
                            .font(.system(size: 13))
                            .padding()
                        Divider()
                        ScrollView {
                            LazyVGrid(columns: gridColumns) {
                                ForEach(designs, id: \.design.id) { item in
                                    GeometryReader { geo in
                                        NavigationLink(destination: DesignDetailView(viewModel: DesignDetailViewModel(postModel: item))) {
                                            GridItemView(size: geo.size.width, item: item)
                                        }
                                    }
                                    .aspectRatio(1, contentMode: .fit)
                                    .padding(.bottom)
                                }
                            }
                            .padding()
                       }

                    }
                    .navigationBarTitle(viewModel.user.name)
                } else {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .onAppear {
                viewModel.fetchUserInfo()
            }
    }
}

struct GridItemView: View {
    let size: Double
    let item: PostModel


    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: item.design.designURL)!) { image in
                image
                    .resizable()
                    .frame(width: size, height: size)
                    .aspectRatio(contentMode: .fill)
                   
            } placeholder: {
                ProgressView()
            }
            .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
    }
}

