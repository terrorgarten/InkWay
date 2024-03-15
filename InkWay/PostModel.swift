//
//  PostModel.swift
//  InkWay
//
//  Created by Adam Valent on 15/03/2024.
//

import Foundation
import SwiftUI

// TODO: maybe create models that map to DB on firestore AND models that are used by views?
struct PostModel : Hashable {
    var artistName: String
    var tags: [String]
    var images: [UIImage]
}
