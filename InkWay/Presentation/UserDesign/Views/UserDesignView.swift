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
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Spacer()
                    }
                    .frame(maxHeight: .infinity)
                } else if viewModel.posts.isEmpty {
                    Text("You have no designs yet. Go to My designs tab and add some.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    VStack {
                    Spacer()
                        ScrollView {
                            LazyVGrid(columns: gridColumns) {
                                ForEach(viewModel.posts, id: \.design.id) { item in
                                    GeometryReader { geo in
                                        NavigationLink(destination: DesignDetailView(viewModel: DesignDetailViewModel(postModel: item))) {
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
