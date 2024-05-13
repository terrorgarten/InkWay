//
//  ArtistCardView.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import SwiftUI


// View for showing the individual artist cards in the browser view (FindArtists)
//struct ArtistCardView: View {
//
//    @StateObject var viewModel: ArtistCardViewModel
//
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack {
//                Spacer()
//                Text(viewModel.artist.name)
//                    .font(.system(size: 32))
//                    .bold()
//                Text(viewModel.artist.surename)
//                    .font(.system(size: 32))
//                    .bold()
//                Spacer()
//            }
//            .padding()
//
//            if viewModel.cityName != "" {
//                HStack {
//                    Text("City")
//                        .foregroundColor(Color.mint)
//                    Spacer()
//                    Text(viewModel.cityName)
//                }
//                .padding()
//            }
//
//            if viewModel.artist.instagram != "" {
//                HStack {
//                    Text("Instagram ")
//                        .foregroundColor(Color.mint)
//                    Spacer()
//                    Text("@\(viewModel.artist.instagram)")
//                }
//            }
//
//            if let image = viewModel.image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                    .padding()
//            }
//
//            if let distance = viewModel.distance {
//                HStack {
//                    Spacer()
//                    if distance != 0 {
//                        Text("\(distance)km")
//                            .padding()
//                            .font(.subheadline)
//                            .background(Color.black)
//                            .foregroundColor(.accentColor)
//                            .cornerRadius(10)
//                    } else {
//                        Text("unknown")
//                            .padding()
//                            .font(.subheadline)
//                            .background(Color.black)
//                            .foregroundColor(.pink)
//                            .cornerRadius(10)
//                    }
//                    Spacer()
//                }
//                .padding()
//            }
//        }
//        .padding()
//        .onAppear {
//            viewModel.getArtistImage()
//            viewModel.setDistance()
//        }
//    }
//
//}
