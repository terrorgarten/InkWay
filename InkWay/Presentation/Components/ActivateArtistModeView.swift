//
//  ActivateArtistModeView.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import SwiftUI
import CoreLocation
import MapKit
import LocationPicker


// View for switching the app context. Reacts with the user
// profile view which pings into the main view afterwards.
//struct ActivateArtistModeView: View {
//    
//    @State private var editedUser: UserModel
//    @State private var coordinates: CLLocationCoordinate2D
//    @State private var showSheet = false
//    @State private var message = ""
//    
//    // san francisco location
//    private let defaultLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
//    private let viewModel: UserProfileViewModel
//    
//    
//    init(user: UserModel, viewModel: UserProfileViewModel) {
//        _editedUser = State(initialValue: user)
//        self.viewModel = viewModel
//        if user.isValidCoordinates() {
//            coordinates = CLLocationCoordinate2D(latitude: CLLocationDegrees(user.coord_y), longitude: CLLocationDegrees(user.coord_x))
//        } else {
//            coordinates = defaultLocation
//        }
//    }
//    
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    Section(
//                        header: Text("Enable artist mode")
//                            .foregroundColor(.accentColor)
//                    ) {
//                        Toggle("Artist mode", isOn: $editedUser.artist)
//                            .foregroundColor(.accentColor)
//                            .padding()
//                    }
//                    if $editedUser.artist.wrappedValue {
//                        Section(
//                        header: Text("Your location")
//                            .foregroundColor(.accentColor)
//                        ) {
//                            Text("\(coordinates.latitude), \(coordinates.longitude)")
//                            Button("Select your location") {
//                                self.showSheet.toggle()
//                            }
//                            .foregroundColor(.accentColor)
//                            .padding()
//                        }
//                    }
//                }
//                Spacer()
//                Text($message.wrappedValue)
//                    .foregroundColor(Color.green)
//            }
//        }
//        .sheet(isPresented: $showSheet) {
//            NavigationView {
//                // DISCLAIMER - REUSED COMPONENT FROM GITHUB. SEE LOCATION PICKER PACKAGE.
//                LocationPicker(instructions: "Select your studio location", coordinates: $coordinates)
//                    .navigationTitle("Location Picker")
//                    .navigationBarTitleDisplayMode(.inline)
//                    .navigationBarItems(trailing: Button(action: {
//                        showSheet.toggle()
//                        editedUser.saveCLLocation(location: coordinates)
//                        message = "All saved."
//                    }, label: {
//                        Text("Save")
//                            .padding(5)
//                            .background(RoundedRectangle(cornerRadius: 10)
//                                .fill(Color.mint))
//                            .foregroundColor(.white)
//                    }))
//            }
//        }
//        .navigationTitle("Artist location")
//        .navigationBarTitleDisplayMode(.inline)
//        .onDisappear {
//            viewModel.updateUserAsArtist(editedUser)
//        }
//    }
//    
//}
