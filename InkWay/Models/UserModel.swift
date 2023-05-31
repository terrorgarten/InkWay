//
//  UserModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation

struct UserModel: Codable {
    let id: String
    var name: String
    var surename: String
    var instagram: String
    let email: String
    let joined: TimeInterval
    let role: String
}
