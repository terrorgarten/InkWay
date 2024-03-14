//
//  UserFeedView.swift
//  InkWay
//
//  Created by Adam Valent on 14/03/2024.
//

import SwiftUI

struct UserFeedView: View {
    @StateObject var viewModel = UserFeedViewModel()
    
    var body: some View {
        NavigationStack {
            Picker("Feed", selection: $viewModel.selectedFeed) {
                Text("Near me")
                Text("Follwing")
            }
            .frame(width: 200.0)
            List {
                Text("Hello, World!")
                Text("Hello, World!")
                Text("Hello, World!")
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
