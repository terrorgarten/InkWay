//
//  UserDetailViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation

class UserDetailViewModel : ObservableObject {
    @Published var designs: [PostModel]? = nil
    @Published var user: UserModel
    
    init(userModel: UserModel) {
        self.user = userModel
    }

    func handleFollowAction(following: Bool) {
        
    }
}
