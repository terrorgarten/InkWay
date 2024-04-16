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
    
    private let userId: String
    
    
    init(userId: String) {
        self.userId = userId
    }
    
    
    var body: some View {
        NavigationView {
            if viewModel.designs.isEmpty {
                Text("Why not add some designs?")
                    .padding()
                    .foregroundColor(.accentColor)
            } else {
                VStack {
                Text("Please note that only the first image is viewed on your profile when people find you!")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
                    .padding()
                Spacer()
                List {
                    ForEach(viewModel.designs.indices, id: \.self) { index in
                        let design = viewModel.designs[index]
                        
                        VStack(alignment: .leading) {
                            AsyncImage(url: design.designURL) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .scaledToFill()
                                        .foregroundColor(.accentColor)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding()
                                case .failure:
                                    Image(systemName: "exclamationmark.icloud")
                                        .font(.largeTitle)
                                        .foregroundColor(.red)
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.deleteDesign(withID: design.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding()
                                }
                                Spacer()
                            }
                        }
                        .padding()
                        .background(index == 0 ? Color.mint.opacity(0.5) : Color.clear)
                        .listRowInsets(EdgeInsets())
                        }
                    }
                }
            }
        }
        .navigationBarTitle("My designs")
        .onAppear {
            viewModel.fetchUserDesigns(for: userId)
        }
        .onDisappear {
            viewModel.stopListening()
        }
    }
    
}
