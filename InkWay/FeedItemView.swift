//
//  FeedItemView.swift
//  InkWay
//
//  Created by Adam Valent on 14/03/2024.
//

import SwiftUI

struct FeedItemView: View {
    let artistName: String
    let tags: [String]
    
    var body: some View {
        // TODO: replace with the artist profile picture
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                // TODO: replace with artist's profile picture
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                Text(artistName)
                    .fontWeight(.semibold)
                Spacer()
                // TODO: add expand functionality with options
                Image(systemName: "ellipsis")
            }
            .padding(.horizontal, 20.0)
            ZStack(alignment: .bottomLeading){
                // TODO: replace with photo swiper
                // TODO: fetch picture from firebase
                AsyncImage(url: URL(string: "future.link.to.picture")){
                    image in image.resizable()
                } placeholder: {
                    Color.green
                }
                .frame(height: 400)
                HStack {
                    Label {
                        Text("Like")
                    } icon: {
                        Image(systemName: "suit.heart")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    .frame(alignment: .bottomLeading)
                    .padding(5)
                    .background(.gray)
                    .clipShape(Capsule().scale(1.15))
                    .opacity(0.5)
                    .padding(10)
                    .frame(alignment: .leading)
                    Spacer()
                    // TODO: replace by swiper indicator like on instagram
                    Image(systemName: "ellipsis")
                        .resizable()
                        .frame(width: 50, height: 10, alignment: .center)
                    // TODO: Come with a solution how to center swiper indicator
                    Spacer(minLength: 160)
                }
            }
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(.gray)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 5)
            Spacer()
        }
    }
}

struct FeedItemView_Previews: PreviewProvider {
    static var previews: some View {
        FeedItemView(artistName: "YakuzaCustoms", tags: ["Japan", "Abstract", "Mystic"])
    }
}
