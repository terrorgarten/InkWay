//
//  UserFeedViewModel.swift
//  InkWay
//
//  Created by Adam Valent on 14/03/2024.
//

import Foundation

class UserFeedViewModel : ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFeed: String = "Near me"
}
