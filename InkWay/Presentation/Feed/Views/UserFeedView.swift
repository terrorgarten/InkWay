//
//  UserFeedView.swift
//  InkWay
//
//  Created by Adam Valent on 24/04/2024.
//

import SwiftUI

struct UserFeedView: View {
    @StateObject var viewModel = UserFeedViewModel()
    @State private var showFilters = false
    @State private var selection: [Tag] = []
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Feed selection", selection: $viewModel.selectedFeed) {
                    ForEach(0 ..< viewModel.feedTypes.count, id: \.self) {
                        Text(viewModel.feedTypes[$0])
                            .tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200.0)
                VStack {
                    if viewModel.isLoading {
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ScrollView{
                            ForEach (viewModel.selectedFeed == 0 ? viewModel.nearmePosts : viewModel.followingPosts, id: \.design.id) { post in
                                FeedItemView(viewModel: viewModel, postModel: post, isLiked: post.isLiked)
                                Divider()
                            }
                            .listRowSeparator(.hidden, edges: .all)
                        }.id(viewModel.selectedFeed)
                    }
                }
                .listStyle(.plain)
            
            }
            .pickerStyle(.segmented)
            .frame(alignment: .top)
            .sheet(isPresented: $showFilters) {
                FiltersView(distatnce: $viewModel.distance, isPresented: $showFilters, selection: $selection)
                    .accentColor(.mint)
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showFilters = true
                    }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .padding()
                    }
                }
            }
            .onChange(of: selection) { _ in
                viewModel.filterPostsByFlags(selectedTags: selection)
            }
            .onAppear {
                viewModel.fetchPosts()
            }
        }
    }
        
}

struct UserFeedView_Previews: PreviewProvider {
    static var previews: some View {
        UserFeedView()
    }
}
