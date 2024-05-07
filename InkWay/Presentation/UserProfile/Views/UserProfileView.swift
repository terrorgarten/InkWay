//
//  UserProfileView.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import SwiftUI
import CoreLocation
import LocationPicker

// serves the entire user view, calls artist changer and the edit sheet
struct UserProfileView: View {
    @StateObject var viewModel: UserProfileViewModel
    @State private var isShowingEditView = false
    @State private var isShowingArtistView = false
    @State private var isLogOutDialogShowed = false
    @State private var coordinates: CLLocationCoordinate2D =  CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @State private var isShowingLocationSheet = false
    @State var darkMode : Bool =  false
    @State private var isShowingLikedPostsView = false

    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    Form {
                        Group {
                            HStack{
                                Spacer()
                                VStack {
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
                                    .padding(.top)
                                    Text(user.name)
                                        .font(.title)
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    if user.artist {
                                        Text("Followers: 32")
                                            .font(.system(.headline))
                                    }
                                    Spacer()
                                    Button(action: {
                                        isShowingEditView = true
                                    }) {
                                        Text("Edit Profile")
                                            .frame(minWidth: 0, maxWidth: .infinity)
                                            .font(.system(size: 18))
                                            .padding()
                                            .foregroundColor(.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .stroke(Color.white, lineWidth: 2)
                                            )
                                    }
                                    .background(Color.accentColor)
                                    .cornerRadius(25)
                                    HStack {
                                        Text("You are here since:")
                                        Spacer()
                                        Text(user.joined.formattedDate())
                                    }
                                    .foregroundColor(.gray)
                                    .padding(.vertical)
                                    HStack {
                                        Text("Your location:")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(viewModel.cityName)
                                    }
                                    .foregroundColor(.gray)
                                    .padding(.bottom)
                                }
                                Spacer()
                            }
                        }
                        
                        if user.artist {
                            Section(header: Text("ARTIST SETTINGS")) {
                                VStack {
                                    Button("Change your location") {
                                        self.isShowingLocationSheet.toggle()
                                    }
                                    .foregroundColor(.black)
                                }
                            }
                        }
                        
                        Section(header: Text("CONTENT"), content: {
                            NavigationLink(destination: LikedPostsView(posts: $viewModel.likedPosts)) {
                                HStack{
                                    Image(systemName: "heart")
                                    Text("Liked designs")
                                }
                            }
                            
                            NavigationLink(destination: ArtistsListView(navigationTitle: "Followed artists", users: viewModel.follwoedArtits)) {
                                HStack{
                                    Image(systemName: "person.3")
                                    Text("Followed artists")
                                }
                            }
                            
                            if user.artist {
                                NavigationLink(destination: ArtistsListView(navigationTitle: "Followers", users: viewModel.follwoedArtits)) {
                                    HStack{
                                        Image(systemName: "person.3.sequence")
                                        Text("Followers")
                                    }
                                }
                            }
                        })
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                        .padding()
                    Text("Loading your profile...")
                        .padding()
                }
            }
            .navigationBarTitle("My profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button(action: {
                    isLogOutDialogShowed = true
                }) {
                    Text("Log out")
                }
            )
            .sheet(isPresented: $isShowingEditView) {
                if let user = viewModel.user {
                    EditUserProfileView(user: user, isShowingEditView: $isShowingEditView, viewModel: viewModel)
                }
            }
            .sheet(isPresented: $isShowingLocationSheet) {
                if var user = viewModel.user {
                    NavigationView {
                        // DISCLAIMER - REUSED COMPONENT FROM GITHUB. SEE LOCATION PICKER PACKAGE.
                        LocationPicker(instructions: "Select your studio location", coordinates: $coordinates)
                            .navigationTitle("Location Picker")
                            .navigationBarTitleDisplayMode(.inline)
                            .navigationBarItems(trailing: Button(action: {
                                isShowingLocationSheet.toggle()
                                user.saveCLLocation(location: coordinates)
                                viewModel.updateUserAsArtist(user)
                            }, label: {
                                Text("Save")
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.mint))
                                    .foregroundColor(.white)
                            }))
                    }
                }
            }
            .confirmationDialog("Are you sure you want to log out?",
                                isPresented: $isLogOutDialogShowed) {
                Button("Log out", role: .destructive) {
                    viewModel.logout()
                }
            }
            .onAppear(perform: viewModel.fetchCurrentUser)
        }
    }
}
