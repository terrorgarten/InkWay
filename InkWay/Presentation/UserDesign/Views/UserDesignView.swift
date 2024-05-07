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
    @State private var showEditView = false
    @State private var showAddView = false
    @State private var showDeleteAllert = false
    
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
                                        Menu {
                                            HStack {
                                                Button(action: {
                                                    viewModel.chosenPost = item
                                                    showEditView.toggle()
                                                }) {
                                                    Image(systemName: "square.and.pencil")
                                                    Text("Edit")
                                                }
                                            }
                                            HStack {
                                                Button(action: {
                                                    viewModel.chosenPost = item
                                                    showDeleteAllert.toggle()
                                                }) {
                                                    Image(systemName: "trash")
                                                        .foregroundColor(.red)
                                                    Text("Delete")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                        } label: {
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(){
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: { showAddView.toggle() }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
            }
        }
        .sheet(isPresented: $showAddView, content: {
            UploadDesignView(isViewShowing: $showAddView, posts: $viewModel.posts)
                .accentColor(.mint)
        })
        .sheet(isPresented: $showEditView, content: {
            if let post = viewModel.chosenPost {
                EditDesignView(viewModel: EditDesignViewModel(postModel: post), isViewShowing: $showEditView, posts: $viewModel.posts)
                    .accentColor(.mint)
            }
        })
        .onAppear {
            viewModel.fetchUserDesigns(for: userId)
        }
        .alert("Are you sure you want to delete this design", isPresented: $showDeleteAllert) {
            if let design = viewModel.chosenPost?.design {
                Button("Yes", role: .destructive) {
                    viewModel.deleteDesign(withID: design.id)
                    showDeleteAllert.toggle()
                }
                Button("No", role: .cancel) {
                    showDeleteAllert.toggle()
                }
            }
        }
    }
    
}
