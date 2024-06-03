//
//  UserDetailView.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import SwiftUI

struct UserDetailView: View {
    @StateObject var viewModel: UserDetailViewModel
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    @State private var showUnfollowConfirmation = false
    
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
                            if viewModel.userFollows {
                                IWPrimaryButton(title: String(localized: "Unfollow"), color: Color.gray, action: {
                                    showUnfollowConfirmation = true
                                })
                                .frame(maxWidth: 180)
                                .alert(isPresented: $showUnfollowConfirmation) {
                                    Alert(
                                        title: Text("Unfollow"),
                                        message: Text("Are you sure you want to unfollow this user?"),
                                        primaryButton: .destructive(Text("Unfollow")) {
                                            viewModel.userFollows = false
                                            viewModel.handleFollowAction(following: viewModel.userFollows)
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }
                            } else {
                                IWPrimaryButton(title: String(localized: "Follow"), color: Color.accentColor, action: {
                                    viewModel.userFollows = true
                                    viewModel.handleFollowAction(following: viewModel.userFollows)
                                })
                                .frame(maxWidth: 180)
                            }
                            HStack {
                                VStack{
                                    Text("Followers")
                                        .font(.system(.headline))
                                    Text(String(viewModel.user.followersCount))
                                        .font(.system(.subheadline))
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    if viewModel.user.instagram != "" {
                        Divider()
                        HStack {
                            Text("Contact")
                                .font(.system(.headline))
                                .padding()
                            Spacer()
                            Button(action: {
                                let appURL = URL(string: "instagram://direct/new?username=\(viewModel.user.instagram)")!
                                let webURL = URL(string: "https://www.instagram.com/\(viewModel.user.instagram)")!
                                
                                if UIApplication.shared.canOpenURL(appURL) {
                                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                                }
                            }) {
                                HStack {
                                    Text("@ " + viewModel.user.instagram)
                                        .font(.system(.subheadline))
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 15))
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                        
                    Divider()
                    
                    HStack {
                        Text("About")
                            .font(.system(.headline))
                            .padding()
                        Spacer()
                    }
                    Text(viewModel.user.bio)
                        .font(.system(size: 13))
                        .padding()
                        .multilineTextAlignment(.leading)
                    Divider()
                    
                    VStack {
                        HStack{
                            Text("Location")
                                .font(.system(.headline))
                                .padding()
                            Spacer()
                            
                            Text(viewModel.location)
                                .font(.system(.subheadline))
                                .padding()
                            
                        }
                        IWMapView(latitude: viewModel.user.coord_x, longitude: viewModel.user.coord_y, label: viewModel.user.name)
                            .cornerRadius(10)
                            .padding()
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Designs")
                            .font(.system(.headline))
                            .padding()
                        Spacer()
                    }
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

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(viewModel: UserDetailViewModel(userModel: UserModel.sample!))
    }
}
