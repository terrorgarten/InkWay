//
//  UserDesignViews.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//
import SwiftUI



// view for presenting the users already uploaded designs
struct UserDesignView: View {
    
    @StateObject private var viewModel = UserDesignViewModel()
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: 3)
    private let userId: String
    
    
    init(userId: String) {
        self.userId = userId
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.posts.isEmpty {
                    Text("Why not add some designs?")
                        .padding()
                        .foregroundColor(.accentColor)
                } else {
                    VStack {
                    Spacer()
                        ScrollView {
                            LazyVGrid(columns: gridColumns) {
                                ForEach(viewModel.posts) { item in
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
                    }
                }
            }
            .navigationBarTitle("My designs")
        }
        .onAppear {
            viewModel.fetchUserDesigns(for: userId)
        }
        .onDisappear {
            viewModel.stopListening()
        }
    }
    
}
