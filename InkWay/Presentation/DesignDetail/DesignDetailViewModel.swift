//
//  DesignDetailViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation

class DesignDetailViewModel : ObservableObject {
    @Published var post: PostModel
    
    init(postModel: PostModel) {
        self.post = postModel
    }
    
    func handleLikeAction(isLiked: Bool) {
    }

}
