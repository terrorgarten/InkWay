//
//  UserModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation

struct UserModel: Codable {
    let id: String // Firebase Auth (or OAuth) generated OID
    var username: String
    var name: String
    var surename: String
    var instagram: String
    let email: String
    let joined: TimeInterval
    var likedDesigns: [String] // List of design OIDs
    var artist: Bool
    
    // Direct param initializer
    init(id: String, username: String, name: String, surename: String, instagram: String, email: String, joined: TimeInterval, likedDesigns: [String], artist: Bool) {
        self.id = id
        self.username = username
        self.name = name
        self.surename = surename
        self.instagram = instagram
        self.email = email
        self.joined = joined
        self.likedDesigns = likedDesigns
        self.artist = artist
    }
    
    // Dict initializer
    init(from dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? "Unknown"
        self.name = dictionary["name"] as? String ?? ""
        self.surename = dictionary["surename"] as? String ?? ""
        self.instagram = dictionary["instagram"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.joined = dictionary["joined"] as? TimeInterval ?? 0
        self.likedDesigns = dictionary["likedDesigns"] as? [String] ?? []
        self.artist = dictionary["artist"] as? Bool ?? false
    }
    
    // For Firestore insertions
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "username": username,
            "name": name,
            "surename": surename,
            "instagram": instagram,
            "email": email,
            "joined": joined,
            "likedDesigns": likedDesigns,
            "artist": artist
        ]
    }
}
