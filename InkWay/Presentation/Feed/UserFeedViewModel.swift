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
    @Published var distance: Double = 0
    @Published var followingPosts: [PostModel]
    @Published var nearmePosts: [PostModel]
    
    init() {
        followingPosts = followingPostsInitValue
        nearmePosts = nearmePostsInitValue
    }
    
    let feedTypes: [String] = ["Near me", "Following"]
    let followingPostsInitValue: [PostModel] = [
        PostModel(artistName: "YakuzaCustoms", tags: [Tag(text: "Traditional"),
                  Tag(text: "Neo Traditional"),
                  Tag(text: "Realism"),
                  Tag(text: "Watercolor"),
                  Tag(text: "Tribal"),
                  Tag(text: "New School")], imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/CYMm3b2sFbK-png__700.jpg"),
        PostModel(artistName: "YakuzaCustoms", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/63becfd2419ed_minimalist-tattoos-part-3.jpg"),
        PostModel(artistName: "Triad Ink.", tags: [Tag(text: "Traditional"),
                  Tag(text: "Neo Traditional"),
                  Tag(text: "Realism")], imageURL: "https://as1.ftcdn.net/v2/jpg/00/27/18/70/1000_F_27187033_0eNuwjRitZRmOn0bhLDdy5falnAeGlO6.jpg")
    ]
    let nearmePostsInitValue: [PostModel] = [
        PostModel(artistName: "DragonTattoo", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/63bed23ddbd42_minimalist-tattoos-part-3.jpg"),
        PostModel(artistName: "TattooBar", tags: [Tag(text: "Traditional"),
                  Tag(text: "Neo Traditional"),
                  Tag(text: "Tribal"),
                  Tag(text: "New School")], imageURL: "https://as1.ftcdn.net/v2/jpg/01/04/09/24/1000_F_104092478_sXDzWd9BYZqMrHAf6RPKXFWNnphVPAA8.jpg"),
        PostModel(artistName: "InkSpired", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/63becc8a3600e_minimalist-tattoos-part-3.jpg"),
        PostModel(artistName: "DragonTattoo", tags: sampleTags, imageURL: "https://as1.ftcdn.net/v2/jpg/04/95/09/36/1000_F_495093660_dXmdyUVKyOMn3Kah2L5WAbnQgramXjyh.jpg")
    ]
    
    var posts: [PostModel] {
        return selectedFeed == 0 ? nearmePosts : followingPosts
    }
    var filteredPosts: [PostModel] {
        guard !searchText.isEmpty else { return posts }
        
        return posts.filter {
            post in post.artistName.lowercased().contains(searchText.lowercased()) ||
            !post.tags.filter{
                tag in tag.text.lowercased().contains(searchText.lowercased())
            }.isEmpty
        }
    }
    
    func filterPostsByFlags(selectedTags: [Tag]) {
        if selectedTags.isEmpty {
            followingPosts = followingPostsInitValue
            nearmePosts = nearmePostsInitValue
            return
        }
        followingPosts = followingPostsInitValue.filter { post in
            post.tags.contains { tag in
                selectedTags.contains { $0.text == tag.text }
            }
        }
        nearmePosts = nearmePostsInitValue.filter { post in
            post.tags.contains { tag in
                selectedTags.contains { $0.text == tag.text }
            }
        }
    }
    
}

struct PostModel : Hashable, Identifiable {
    var id = UUID()
    let artistName: String
    let tags: [Tag]
    let imageURL: String
}
