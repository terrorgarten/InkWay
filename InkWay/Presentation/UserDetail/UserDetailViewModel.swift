//
//  UserDetailViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation

class UserDetailViewModel : ObservableObject {
    @Published var followingPosts: [PostModel] = [
        PostModel(artistName: "YakuzaCustoms", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/CYMm3b2sFbK-png__700.jpg"),
        PostModel(artistName: "YakuzaCustoms", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/CYMm3b2sFbK-png__700.jpg"),
        PostModel(artistName: "YakuzaCustoms", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/CYMm3b2sFbK-png__700.jpg"),
        PostModel(artistName: "YakuzaCustoms", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/CYMm3b2sFbK-png__700.jpg"),
        PostModel(artistName: "YakuzaCustoms", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/CYMm3b2sFbK-png__700.jpg"),
        PostModel(artistName: "YakuzaCustoms", tags: sampleTags, imageURL: "https://www.boredpanda.com/blog/wp-content/uploads/2023/01/CYMm3b2sFbK-png__700.jpg"),
    ]
}

