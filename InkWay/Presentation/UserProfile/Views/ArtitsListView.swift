//
//  ArtitsListView.swift
//  InkWay
//
//  Created by Oliver Bajus on 04.05.2024.
//

import Foundation
import SwiftUI

struct ArtistsListView: View {
    var users: [UserModel]
    let navigationTitle: String
    
    
    init(navigationTitle: String, users: [UserModel]) {
        self.navigationTitle = navigationTitle
        self.users = users
    }
    
    var body: some View {
        ScrollView {
            ForEach (users, id: \.id) { user in
                NavigationLink {
                   UserDetailView(viewModel: UserDetailViewModel(userModel: user))
                } label: {
                    HStack {
                        AsyncImage(url: user.profilePictureURL){ image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .cornerRadius(100)
                        } placeholder: {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(width: 30, height: 30)
                        }
                        .frame(height: 30)
                        .padding(4)
                        Text(user.name)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(2)
                }
                Divider()
            }
            .listRowSeparator(.hidden, edges: .all)
       }
        .navigationTitle(navigationTitle)
    }
}
