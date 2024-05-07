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
                            AsyncImage(url: viewModel.post.design.designURL){
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
                                            .font(.system(size: 25))
                                        Spacer()
                                        HStack {
                                            Button(action: {
                                                viewModel.post.isLiked.toggle()
                                                viewModel.handleLikeAction(isLiked: viewModel.post.isLiked)
                                            }
                                            ){
                                                Image (systemName: viewModel.post.isLiked ? "heart.fill" : "heart")
                                                    .font(.system(size: 25))
                                                    .foregroundColor(viewModel.post.isLiked ? Color.red : Color.gray)
                                                    .padding(5)
                                            }
                                        }
                                    }
                                    Text("Estimated price: " + String(viewModel.post.design.price))
                                        .font(.system(size: 15))
                                    
                                }
                                Spacer()
                            }
                            
                            WrappingHStack(viewModel.post.design.tags, id: \.self) { tag in
                                IWTag(text: tag)
                                    .padding(.vertical, 2)
                            }
                            .padding(.bottom, 5)
                            .padding(.horizontal, 5)
                            
                            VStack(alignment: .leading) {
                                Text("Artist:")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                HStack(alignment: .top) {
                                    NavigationLink(destination: UserDetailView(viewModel: UserDetailViewModel(userModel: viewModel.post.artist))) {
                                        AsyncImage(url: viewModel.post.artist.profilePictureURL){ image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 70, height: 70)
                                                .cornerRadius(100)
                                        } placeholder: {
                                            ProgressView()
                                                .progressViewStyle(.circular)
                                                .frame(width: 70, height: 70)
                                        }
                                        .frame(height: 70)
                                        Text(viewModel.post.artist.name)
                                            .font(.system(size: 20))
                                    }
                                    .foregroundColor(.black)
                                }
                                
                                Text("Description:")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .bold()
                                    .padding(.top)
                                Text(viewModel.post.design.description)
                                    .font(.system(size: 15))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(.top)
                            .lineLimit(nil)
                        }.padding(.horizontal)
                    }
                    .padding(.bottom, 100)
                }
                
                IWPrimaryButton(title: String(localized: "Book"), color: Color.accentColor, action: {})
                    .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle("Post detail")
    }
}
