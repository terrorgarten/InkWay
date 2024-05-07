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
    let designURL: String
    let userId: String
    let description: String
    let tags: [String]
    let name: String
    let price: Int
    
    init(designId: UUID = UUID(), designURL: String, userId: String, description: String, tags: [String], name: String, price: Int) {
        self.id = designId
        self.designURL = designURL
        self.userId = userId
        self.description = description
        self.tags = tags
        self.name = name
        self.price = price
    }
}
