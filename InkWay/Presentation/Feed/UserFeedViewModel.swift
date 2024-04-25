//
//  UserFeedViewModel.swift
//  InkWay
//
//  Created by Adam Valent on 24/04/2024.
//

import Foundation
import SwiftUI

class UserFeedViewModel : ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFeed = 0
    let feedTypes: [String] = ["Near me", "Following"]
    @Published var followingPosts: [PostModel] = [
        PostModel(artistName: "YakuzaCustoms", tags: ["#Japan", "#Abstract", "#Mystic"], imageURL: "https://as1.ftcdn.net/v2/jpg/04/10/64/90/1000_F_410649002_XdCaHGEI2SVcHGOgelgeC9hFVZROyRTL.jpg"),
        PostModel(artistName: "YakuzaCustoms", tags: ["#Japan", "#KoiKoi", "#Traditional"], imageURL: "https://as2.ftcdn.net/v2/jpg/04/10/64/89/1000_F_410648990_hiPWmTRjc1EdMhdlvuAQbVNybIQTMsot.jpg"),
        PostModel(artistName: "Triad Ink.", tags: ["#China", "#Dragon", "#Historic", "#Realistic", "#Shangai"], imageURL: "https://as1.ftcdn.net/v2/jpg/00/27/18/70/1000_F_27187033_0eNuwjRitZRmOn0bhLDdy5falnAeGlO6.jpg")
    ]
    @Published var nearmePosts: [PostModel] = [
        PostModel(artistName: "DragonTattoo", tags: ["#Realistic", "#B&W", "#Wild"], imageURL: "https://as1.ftcdn.net/v2/jpg/05/64/67/48/1000_F_564674884_1bTiQkVe09psYrFIrGzMGXHzSXRKwXn1.jpg"),
        PostModel(artistName: "TattooBar", tags: ["#Brno", "#CZ", "#Minimalistic"], imageURL: "https://as1.ftcdn.net/v2/jpg/01/04/09/24/1000_F_104092478_sXDzWd9BYZqMrHAf6RPKXFWNnphVPAA8.jpg"),
        PostModel(artistName: "InkSpired", tags: ["#CZSK", "#Cute", "#Pet"], imageURL: "https://as1.ftcdn.net/v2/jpg/02/47/48/42/1000_F_247484208_zHHIp6IGPDwZVFeLwitotrILEizGhirX.jpg"),
        PostModel(artistName: "DragonTattoo", tags: ["#DigitalArt", "#Eagle", "#Colors"], imageURL: "https://as1.ftcdn.net/v2/jpg/04/95/09/36/1000_F_495093660_dXmdyUVKyOMn3Kah2L5WAbnQgramXjyh.jpg")
    ]
    var posts: [PostModel] {
        return selectedFeed == 0 ? nearmePosts : followingPosts
    }
    var filteredPosts: [PostModel] {
        guard !searchText.isEmpty else { return posts }
        
        return posts.filter {
            post in post.artistName.lowercased().contains(searchText.lowercased()) ||
            !post.tags.filter{
                tag in tag.lowercased().contains(searchText.lowercased())
            }.isEmpty
        }
    }
}

struct PostModel : Codable, Hashable {
    let artistName: String
    let tags: [String]
    let imageURL: String
}
