//
//  UserFeedViewModel.swift
//  InkWay
//
//  Created by Adam Valent on 14/03/2024.
//

import Foundation

class UserFeedViewModel : ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFeed: String = ""
    @Published var posts: [PostModel] = [
        PostModel(artistName: "YakuzaCustoms", tags: ["#Japan", "#Abstract", "#Mystic"], images: []),
        PostModel(artistName: "YakuzaCustoms", tags: ["#Japan", "#Punk", "#Future"], images: []),
        PostModel(artistName: "Triad", tags: ["#China", "#Dragon", "#Historic", "#Realistic", "#Shangai"], images: [])
    ]
}
