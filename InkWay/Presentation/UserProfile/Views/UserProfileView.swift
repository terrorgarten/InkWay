//
//  UserProfileView.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//
import SwiftUI
import CoreLocation
import LocationPicker
import PhotosUI

struct UserProfileView: View {
    @StateObject var viewModel: UserProfileViewModel
    @State private var isShowingEditView = false
    @State private var isShowingArtistView = false
    @State private var isLogOutDialogShowed = false
    @State private var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    @State private var isShowingLocationSheet = false
    @State private var isShowingLikedPostsView = false
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State private var isShowingProfilePictureOptions = false
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    Form {
                        Group {
                            HStack{
                                Spacer()
                                VStack {
                                    ZStack {
                                        AsyncImage(url: user.profilePictureURL){ image in
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
                                        .onTapGesture {
                                            isShowingProfilePictureOptions = true
                                        }
                                        
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Spacer()
                                                Image(systemName: "pencil.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.7))
                                                    .clipShape(Circle())
                                                    .font(.title2)
                                                    .padding(.leading, 40)
                                                Spacer()
                                            
                                            }
                                        }
                                    }
                                    Text(user.name)
                                        .font(.title)
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    if user.artist {
                                        Text(user.bio)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                    
                                    Spacer()
                                    
                                    
                                    VStack {
                                        HStack {
                                            Text("You are here since:")
                                            Spacer()
                                            Text(user.joined.formattedDate())
                                        }
                                        .foregroundColor(.gray)
                                        .padding(.vertical)
                                        
                                        IWPrimaryButton(title: "Edit profile info", color: .accentColor, action: {
                                            isShowingEditView = true
                                        })
                                    }
                                    
                                }
                                Spacer()
                            }
                        }
                        
                        
                        
                        Section(header: Text("CONTENT"), content: {
                            NavigationLink(destination: LikedPostsView(posts: $viewModel.likedPosts)) {
                                HStack{
                                    Image(systemName: "heart")
                                    Text("Liked designs")
                                    Spacer()
                                    Text(String(user.likedDesignsCount))
                                }
                            }
                            
                            NavigationLink(destination: ArtistsListView(navigationTitle: "Followed artists", users: viewModel.followedArtits)) {
                            HStack{
                                Image(systemName: "person.3")
                                Text("Followed artists")
                                Spacer()
                                Text(String(user.followedArtistsCount))
                            }
                            }
                            
                            if user.artist {
                                NavigationLink(destination: ArtistsListView(navigationTitle: "Followers", users: viewModel.followers)) {
                                    HStack{
                                        Image(systemName: "person.3.fill")
                                        Text("Followers")
                                        Spacer()
                                        Text(String(user.followersCount))
                                    }
                                }
                            }
                        })
                        
                        if user.artist {
                            Section(header: Text("ARTIST SETTINGS")) {
                                
                                VStack {
                                    IWMapView(latitude: user.coord_x, longitude: user.coord_y, label: user.name)
                                        .cornerRadius(6)
                                        .padding(.horizontal, -10)
                                    
                                    if user.artist {
                                        HStack {
                                            Text("Location:")
                                            Spacer()
                                            Text(String(viewModel.cityName))
                                        }
                                        .foregroundColor(.gray)
                                        .padding(.vertical)
                                    }
                                    
                                    IWPrimaryButton(title: "Change location", color: .accentColor, action: {
                                        isShowingLocationSheet = true
                                    })
                                }
                            }
                        }
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
                        LocationPicker(instructions: "Select your studio location", coordinates: $coordinates)
                            .navigationBarItems(trailing: Button(action: {
                                isShowingLocationSheet.toggle()
                                user.saveCLLocation(location: coordinates)
                                print("User location updated")
                                print(user.coord_x, user.coord_y)
                                viewModel.updateUserProfile(user: user)
                            }, label: {
                                Text("Save")
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.blue))
                                    .foregroundColor(.white)
                            }))
                    }
                }
            }
            .confirmationDialog("Are you sure you want to log out?",
                                isPresented: $isLogOutDialogShowed) {
                Button("Confirm log out", role: .destructive) {
                    viewModel.logout()
                }
            }
            .confirmationDialog("Profile Picture Options",
                                isPresented: $isShowingProfilePictureOptions) {
                Button("Change", action: {
                    isShowingImagePicker = true
                })
                Button("Remove", role: .destructive, action: {
                    viewModel.deleteProfilePicture()
                })
                Button("Cancel", role: .cancel, action: {})
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(image: $selectedImage)
                    .onChange(of: selectedImage) { newImage in
                        if let newImage = newImage {
                            viewModel.updateProfilePicture(image: newImage)
                        }
                    }
            }
            .onAppear(perform: viewModel.loadUserProfile)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(viewModel: UserProfileViewModel())
    }
}

// Sample user
extension UserModel {
    static var sample: UserModel? {
        UserModel(id: "awd", name: "John", surename: "piko", instagram: "awd", email: "awd@.com", joined: Double(123))
    }
}
