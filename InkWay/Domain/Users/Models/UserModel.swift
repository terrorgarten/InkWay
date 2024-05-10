//
//  UserModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation


// just simple model. Codable for sending to the DB as JSON
struct UserModel: Codable {
    let id: String // Firebase Auth (or OAuth) generated OID
    var name: String
    var surename: String
    var instagram: String
    let email: String
    let joined: TimeInterval
    var likedDesigns: [String] // List of design OIDs
    var artist: Bool
}
