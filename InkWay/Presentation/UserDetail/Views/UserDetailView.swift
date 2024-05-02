//
//  UserDetailView.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation
import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel = UserDetailViewModel()
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var isFollowing: Bool = false
    @Binding var isPresented: Bool
    
    var body: some View {
            ScrollView {
                VStack(alignment: .center) {
                    Text("LidickaTattos")
                        .fontWeight(.bold)
                        .padding(.top)
                        .font(.system(size: 20))
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            AsyncImage(url: URL(string: "https://www.mensjournal.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_1280/MTk2MTM2NTcwNDMxMjg0NzQx/man-taking-selfie.webp")){ image in
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
                        VStack(alignment: .leading) {
                            if isFollowing {
                                IWPrimaryButton(title: String(localized: "Unfollow"), color: Color.gray, action: {
                                    isFollowing = false
                                })
                                    .frame(maxWidth: 180)
                            } else {
                                IWPrimaryButton(title: String(localized: "Follow"), color: Color.accentColor, action: {
                                    isFollowing = true
                                })
                                    .frame(maxWidth: 180)
                            }
                            
                            Label{
                                Text("Lidická Brno")
                                    .font(.system(size: 13))
                            } icon: {
                                Image(systemName: "house")
                                    .font(.system(size: 13))
                            }
                            .padding(.leading)
                            Label{
                                Text("+420678987678")
                                    .font(.system(size: 13))
                            } icon: {
                                Image(systemName: "phone")
                                    .font(.system(size: 13))
                            }
                            .padding(.leading)
                            Label{
                                Text("lidickatattoo@example.com")
                                    .font(.system(size: 13))
                            } icon: {
                                Image(systemName: "envelope")
                                    .font(.system(size: 13))
                            }
                            .padding(.leading)
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
                            ForEach(viewModel.followingPosts) { item in
                                GeometryReader { geo in
                                    NavigationLink(destination: DesignDetailView(post: item)) {
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
            }
        
    }
}

struct GridItemView: View {
    let size: Double
    let item: PostModel


    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url:  URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
            } placeholder: {
                ProgressView()
            }
            .frame(width: size, height: size)
        }
    }
}

