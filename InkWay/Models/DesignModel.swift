//
//  DesignModel.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import Foundation

// model for representing the relation between Storaged photo and the owning user
struct DesignModel: Identifiable, Codable {
    let id: UUID
    let designURL: URL
    let userId: String
    
    init(designId: UUID = UUID(), designURL: URL, userId: String) {
        self.id = designId
        self.designURL = designURL
        self.userId = userId
    }
}
