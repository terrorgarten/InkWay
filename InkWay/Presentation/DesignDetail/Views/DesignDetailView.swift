//
//  DesignDetail.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation
import SwiftUI
import WrappingHStack

struct DesignDetailView: View {
    @StateObject var viewModel: DesignDetailViewModel
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .center) {
                        ZStack(alignment: .topLeading) {
                            AsyncImage(url: URL(string: viewModel.post.design.designURL)!){
                                image in image.resizable()
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .frame(width: 400, height: 400)
                            }
                            .frame(height: 400)
                            
                        }
                        
                        VStack(alignment: .leading) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(viewModel.post.design.name)
                                            .font(.headline)
                                            .bold()
                                        Spacer()
                                        HStack {
                                            Button(action: {
                                                viewModel.handleLikeAction()
                                                viewModel.post.isLiked.toggle()
                                            }
                                            ){
                                                Image (systemName: viewModel.post.isLiked ? "heart.fill" : "heart")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(viewModel.post.isLiked ? Color.red : Color.gray)
                                                    .padding(5)
                                            }
                                        }
                                    }
                                }
                                Spacer()
                            }
                            
                            WrappingHStack(viewModel.post.design.tags, id: \.self) { tag in
                                IWTag(text: tag)
                                    .padding(.vertical, 2)
                            }
                            .padding(.bottom, 5)
                            .padding(.horizontal, 5)
                            
                            if viewModel.post.design.price > 0 {
                                Divider()
                                HStack{
                                    Text("Estimated price")
                                        .font(.headline)
                                        .padding()
                                    Spacer()
                                    Text("$" + String(viewModel.post.design.price))
                                        .font(.subheadline)
                                        .padding()
                                }
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading) {
                               
                                HStack {
                                    Text("Artist")
                                        .font(.headline)
                                        .padding()
                                    
                                    Spacer()

                                    HStack {
                                        NavigationLink(destination: UserDetailView(viewModel: UserDetailViewModel(userModel: viewModel.post.artist))) {
                                            AsyncImage(url: viewModel.post.artist.profilePictureURL){ image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 50, height: 50)
                                                    .cornerRadius(100)
                                                    .padding()
                                            } placeholder: {
                                                ProgressView()
                                                    .progressViewStyle(.circular)
                                                    .frame(width: 50, height: 50)
                                            }
                                            .frame(height: 50)
                                            
                                            Text(viewModel.post.artist.name)
                                                .font(.subheadline)
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 20))
                                                .foregroundColor(.accentColor)
                                                .padding()
                                        }
                                    }
                                }
                                .padding(.top, -20)
                                
                            
                                if viewModel.post.design.description != "" {
                                    Divider()
                                    Text("Description:")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .bold()
                                        .padding()
                                    Text(viewModel.post.design.description)
                                        .font(.system(size: 15))
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding()
                                }
                            }
                            .padding(.top)
                            .lineLimit(nil)
                        }.padding(.horizontal)
                    }
                    .padding(.bottom, 100)
                }
                                
                IWPrimaryButton(title: String(localized: "Book"), color: Color.accentColor, action: {
                                        
                    let appURL = URL(string: "instagram://direct/new?username=\(viewModel.post.artist.instagram)")!
                    let webURL = URL(string: "https://www.instagram.com/\(viewModel.post.artist.instagram)")!
                    
                    if UIApplication.shared.canOpenURL(appURL) {
                        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                    }
                })
                    .frame(maxWidth: .infinity)
                    .disabled(viewModel.post.artist.instagram.isEmpty)

            }
        }
        .navigationTitle(viewModel.post.design.name)
    }
}

