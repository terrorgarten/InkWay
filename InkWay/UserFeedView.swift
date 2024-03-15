//
//  UserFeedView.swift
//  InkWay
//
//  Created by Adam Valent on 14/03/2024.
//

import SwiftUI

struct UserFeedView: View {
    @StateObject private var viewModel = UserFeedViewModel()
    @State var selectedFeed = 0
    let feedTypes: [String] = ["Near me", "Following"]
    
    var body: some View {
        NavigationStack {
            Picker("Feed selection", selection: $selectedFeed) {
                ForEach(0 ..< feedTypes.count, id: \.self) {
                    Text(feedTypes[$0])
                        .tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200.0)
            ScrollView {
                VStack {
                    ForEach ($viewModel.posts, id: \.self) {
                        post in FeedItemView(model: post.wrappedValue)
                    }
                }
            }
        }
        .listStyle(.plain)
        .searchable(text: $viewModel.searchText)
        .pickerStyle(.segmented)
    }
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedView()
    }
}
