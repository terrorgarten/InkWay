//
//  FeedItemView.swift
//  InkWay
//
//  Created by Adam Valent on 24/04/2024.
//

import SwiftUI
import WrappingHStack

struct FeedItemView: View {
    let model: PostModel
    @State private var liked: Bool = false
    @State private var showPostDetail = false
    @State private var showUserDetail = false
    
    var body: some View {
        // TODO: replace with the artist profile picture
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                NavigationLink(
                    destination:  UserDetailView(isPresented: $showPostDetail)
                                    .accentColor(.mint),
                    label: {
                        Label{
                            Text(model.artistName)
                                .fontWeight(.semibold)
                        } icon: {
                            AsyncImage(url: URL(string: "https://www.mensjournal.com/.image/c_limit%2Ccs_srgb%2Cq_auto:good%2Cw_1280/MTk2MTM2NTcwNDMxMjg0NzQx/man-taking-selfie.webp")){ image in
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
                    Button("Save", action: {})
                    Button("Share", action: {})
                    Button("Unfollow", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 30, height: 7)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 20.0)
            
            ZStack(alignment: .bottomLeading){
                // TODO: fetch image from firebase
                NavigationLink(
                    destination: DesignDetailView(post: model),
                    label: {
                        AsyncImage(url: URL(string: model.imageURL)){
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
                        self.liked = !self.liked
                    }
                    ){
                        Label (liked ? "Liked" : "Like",
                               systemImage: liked ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(liked ? Color.red : Color.white)
                        .padding(5)
                        .background(liked ? .white : .gray.opacity(0.5))
                        .clipShape(Capsule().scale(1.15))
                        .padding(10)
                    }
                }
            }
            .frame(alignment: .center)
            
            WrappingHStack(model.tags, id: \.self) { tag in
                Button(action: {}){
                    Text(tag.text)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                        .padding(.vertical, 2)
                        .padding(.horizontal, 8)
                        .background(.gray.opacity(0.5))
                        .clipShape(Capsule())
                        .padding(.bottom, 10)
                }
                    
            }
            .padding(.bottom, 5)
            .padding(.horizontal, 5)
            Spacer()
        }
        .padding(.bottom, 10)
    }
}

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(model:
                        PostModel(
                            artistName: "YakuzaCustoms",
                            tags: sampleTags,
                            imageURL: "https://as1.ftcdn.net/v2/jpg/05/64/67/48/1000_F_564674884_1bTiQkVe09psYrFIrGzMGXHzSXRKwXn1.jpg"))
    }
}


