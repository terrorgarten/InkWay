//
//  UserFeedView.swift
//  InkWay
//
//  Created by Adam Valent on 24/04/2024.
//

import SwiftUI

struct UserFeedView: View {
    @StateObject var viewModel = UserFeedViewModel()
    
    
    var body: some View {
        NavigationStack {
            Picker("Feed selection", selection: $viewModel.selectedFeed) {
                ForEach(0 ..< viewModel.feedTypes.count, id: \.self) {
                    Text(viewModel.feedTypes[$0])
                        .tag($0)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200.0)
            VStack {
                ScrollView{
                    ForEach (viewModel.filteredPosts, id: \.self) {
                        post in FeedItemView(model: post)
                    }
                    .listRowSeparator(.hidden, edges: .all)
                    // TODO: scroll to top on feed type (near/follow) change
                }.id(viewModel.selectedFeed)
            }
            .listStyle(.plain)
        }
        .searchable(text: $viewModel.searchText)
        .pickerStyle(.segmented)
        .frame(alignment: .top)
    }
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedView()
    }
}
