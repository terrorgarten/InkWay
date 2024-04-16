//
//  FindArtistsView.swift
//  InkWay
//
//  Created by terrorgarten on 30.05.2023.
//

import SwiftUI
import CoreLocationUI
import CoreLocation



// Presents the view that asks for location with the location
// button, then shows the cards for browsing.
struct FindArtistsView: View {
    
    @StateObject private var viewModel = FindArtistsViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.cityName.isEmpty {
                    HStack {
                        Text("Your location:")
                            .padding()
                        Spacer()
                        Text(viewModel.cityName)
                            .padding()
                            .foregroundColor(.accentColor)
                    }
                    
                    ScrollView {
                        LazyVStack(spacing: 45) {
                            ForEach(viewModel.artists, id: \.id) { artist in
                                ArtistCardView(viewModel: ArtistCardViewModel(artist: artist, findArtistsViewModel: viewModel))
                                    .background(Color.gray)
                                    .cornerRadius(25)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 20, x: 10, y: 10)
                                    .padding(15)
                                    .id(artist.id)
                            }
                            Spacer()
                        }
                    }
                    .onAppear {
                        viewModel.fetchUsers()
                    }
                } else {
                    // from library
                    LocationButton(.currentLocation) {
                        viewModel.requestAllowOnceLocationPermission()
                    }
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .labelStyle(.titleAndIcon)
                    .symbolVariant(.fill)
                    .tint(.accentColor)
                    .padding(.bottom, 50)
                    Text("Please allow location once so we can find your closest tattoo artist! Not saving it, we promise!")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .padding()
                }
                
            }
        }
        .navigationBarTitle("Tattoo artists nearby")
    }
    
}
