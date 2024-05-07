//
//  FeedItemView.swift
//  InkWay
//
//  Created by Adam Valent on 24/04/2024.
//

import SwiftUI
import WrappingHStack

struct FeedItemView: View {
    @StateObject var viewModel: UserFeedViewModel
    var postModel: PostModel
    @State private var isLiked = false
    @State private var showPostDetail = false
    @State private var showUserDetail = false
    @State private var showingUnfollowAlert = false
    
    var body: some View {
        // TODO: replace with the artist profile picture
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                NavigationLink(
                    destination: UserDetailView(viewModel: UserDetailViewModel(userModel: postModel.artist))
                                    .accentColor(.mint),
                    label: {
                        Label{
                            Text(postModel.artist.name)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                        } icon: {
                            AsyncImage(url: postModel.artist.profilePictureURL){ image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 40, height: 40)
                                    .cornerRadius(100)
                            } placeholder: {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .frame(width: 40, height: 40)
                            }
                            .frame(height: 40)
                        }
                    }
                )
                .foregroundColor(.black)
                
                Spacer()
                
                Menu {
                    HStack {
                        ShareLink(item: postModel.design.designURL) {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                    }
                    HStack {
                        Button(action: { showingUnfollowAlert = true }) {
                            Image(systemName: "person.slash")
                            Text("Unfollow")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.black)
                        .font(.headline)
                }
            }
            .padding(.horizontal, 20.0)
            
            ZStack(alignment: .bottomLeading){
                // TODO: fetch image from firebase
                NavigationLink(
                    destination:  DesignDetailView(viewModel: DesignDetailViewModel(postModel: postModel)),
                    label: {
                        AsyncImage(url:postModel.design.designURL){
                            image in image.resizable()
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(width: 400, height: 400)
                        }
                        .frame(height: 400)
                    }
                )
                
                HStack {
                    Button(action: {
                        isLiked.toggle()
                    }
                    ){
                        Label (isLiked ? "Liked" : "Like",
                               systemImage: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(isLiked ? Color.red : Color.white)
                        .padding(5)
                        .background(isLiked ? .white : .gray.opacity(0.5))
                        .clipShape(Capsule().scale(1.15))
                        .padding(10)
                    }
                }
            }
            .frame(alignment: .center)
            
            WrappingHStack(postModel.design.tags, id: \.self) { tag in
                IWTag(text: tag)
                    .padding(.vertical, 2)
            }
            .padding(.bottom, 5)
            .padding(.horizontal, 5)
            Spacer()
        }
        .padding(.bottom, 2)
        .alert(isPresented: $showingUnfollowAlert) {
                Alert(
                    title: Text("Unfollow"),
                    message: Text("Are you sure you want to unfollow this user?"),
                    primaryButton: .default(
                        Text("Yes"),
                        action: {}
                    ),
                    secondaryButton: .destructive(
                        Text("No"),
                        action: { showingUnfollowAlert = false }
                    )
                )
            }
    }
}

//struct FeedItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedItemView(model:
//                        PostModel(design: DesignModel(designURL: <#T##URL#>, userId: <#T##String#>, description: <#T##String#>, tags: <#T##[String]#>, name: <#T##String#>, price: <#T##Int#>), artist: <#T##UserModel#>))
//    }
//}


