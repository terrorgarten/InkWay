//
//  DesignDetailViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation

class DesignDetailViewModel : ObservableObject {
    @Published var design: PostModel? = nil
    private let designId: String
    
    init(designId: String) {
        self.designId = designId
    }
    
    func fetchDesign() {
        // TODO - fetch design
    }
    
    func handleLikeAction(isLiked: Bool) {
        
    }

}
