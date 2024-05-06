//
//  SavedDesignsView.swift
//  InkWay
//
//  Created by Oliver Bajus on 04.05.2024.
//

import Foundation
import SwiftUI

struct LikedPostsView: View {
    @Binding var posts: [PostModel]
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns) {
                ForEach(posts) { item in
                    GeometryReader { geo in
                        NavigationLink(destination: DesignDetailView(viewModel: DesignDetailViewModel(designId: ""))) {
                            GridItemView(size: geo.size.width, item: item)
                        }
                    }
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.bottom)
                }
            }
            .padding()
       }
       .navigationTitle("Liked posts")
    }
}
