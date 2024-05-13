//
//  UserProfileView.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import SwiftUI

// serves the entire user view, calls artist changer and the edit sheet
struct UserProfileView: View {
    @StateObject var viewModel: UserProfileViewModel
    @State private var isShowingEditView = false
    @State private var isShowingArtistView = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = viewModel.user {
                    VStack {
                        if let errorMessage = viewModel.errorMsg {
                            Text(errorMessage)
                        }
                        VStack(alignment: .leading) {
                            List {
                                Section(header: Text("User information")) {
                                    HStack {
                                        Text("Name:")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(user.name)
                                    }
                                    HStack {
                                        Text("Email:")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(user.email)
                                    }
                                    HStack {
                                        Text("Surename:")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(user.surename)
                                    }
                                    HStack {
                                        Text("Instagram:")
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text("@")
                                            .foregroundColor(.gray)
                                            .offset(x: 6)
                                        Text(user.instagram)
                                    }
                                }
                                if user.artist {
                                    Section(header: Text("Artist information")) {
                                        HStack {
                                            Text("Location")
                                                .foregroundColor(.gray)
                                            Spacer()
                                            Text(viewModel.cityName)
                                        }
//                                        NavigationLink(destination: ActivateArtistModeView(user: user, viewModel: viewModel)) {
//                                            Text("Change artist info")
//                                                .foregroundColor(.accentColor)
//                                        }
                                    }
                                }
                            }
                            if user.artist {
                                Text("You are now in artist mode. This means that other users can find you based on location in the Find tab. Uploading your designs also became available.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .padding()
                                Spacer()
                            }
                            if !user.artist {
                                // NavigationLink(destination: ActivateArtistModeView(user: user, viewModel: viewModel)) {
                                    Text("Are you an artist? Show yourself!")
                                        .padding()
                                        .foregroundColor(.accentColor)
                                // }
                            }
                            
                            HStack {
                                Text("You are here since:")
                                Spacer()
                                Text(user.joined.formattedDate())
                            }
                            .foregroundColor(.gray)
                            .padding()
                            
                            Spacer()
                            
                            HStack {
                                Button(action: {
                                    viewModel.logout()
                                }, label: {
                                    Text("Log me out")
                                })
                                .tint(.red)
                                .padding()
                                
                                Spacer()
                                
                                Button(action: {
                                    isShowingEditView = true
                                }, label: {
                                    Text("Edit")
                                })
                                .tint(.accentColor)
                                .padding()
                            }
                            .padding()
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
            .navigationBarItems(trailing: Image(systemName: "person.circle").scaledToFill())
            .sheet(isPresented: $isShowingEditView) {
                if let user = viewModel.user {
                    EditUserProfileView(user: user, isShowingEditView: $isShowingEditView, viewModel: viewModel)
                }
            }
            .onAppear(perform: viewModel.fetchCurrentUser)
        }
    }
    
}
