//
//  ArtistModel.swift
//  InkWay
//
//  Created by terrorgarten on 05.05.2024.
//

import Foundation

struct ArtistModel: Codable {
    var bio: String
    var coord_y: Float
    var coord_x: Float
    var followers: [String] // User OIDs
    var followerCount: Int
    var designs: [String] // Design OIDs
}
