//
//  UserModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation


// just simple model. Codable for sending to the DB as JSON
struct UserModel: Codable {
    
    let id: String
        
    var name: String
    var surename: String
    
    var instagram: String
    let email: String
    
    let joined: TimeInterval
    
    var artist: Bool = false
    var bio: String = ""
    var coord_y: Float = defaultCoordinate
    var coord_x: Float = defaultCoordinate
    
    
    var likedDesigns: [String] = []
    var likedDesignsCount: Int = 0
    
    var followedArtists: [String] = []
    var followedArtistsCount: Int = 0
    
    var followers: [String] = []
    var followersCount: Int = 0
    
    var profilePictureURL: URL = URL(string: defaultImageURL)!
    
    // Full init
    init(id: String, name: String, surename: String, instagram: String, email: String, joined: TimeInterval, artist: Bool, bio: String, coord_y: Float, coord_x: Float, likedDesigns: [String], likedDesignsCount: Int, followedArtists: [String], followedArtistsCount: Int, followers: [String], followersCount: Int, profilePictureURL: URL) {
        self.id = id
        self.name = name
        self.surename = surename
        self.instagram = instagram
        self.email = email
        self.joined = joined
        self.artist = artist
        self.bio = bio
        self.coord_y = coord_y
        self.coord_x = coord_x
        self.likedDesigns = likedDesigns
        self.likedDesignsCount = likedDesignsCount
        self.followedArtists = followedArtists
        self.followedArtistsCount = followedArtistsCount
        self.followers = followers
        self.followersCount = followersCount
        self.profilePictureURL = profilePictureURL
    }
    
    init(id: String, name: String, surename: String, instagram: String, email: String, joined: TimeInterval) {
        self.id = id
        self.name = name
        self.surename = surename
        self.email = email
        self.joined = joined
        self.instagram = instagram
    }
    
    // Dictionary initializer
    init(from dict: [String: Any]) {
        self.id = dict["id"] as? String ?? ""
        self.name = dict["name"] as? String ?? ""
        self.surename = dict["surename"] as? String ?? ""
        self.instagram = dict["instagram"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
        self.joined = dict["joined"] as? TimeInterval ?? 0
        self.artist = dict["artist"] as? Bool ?? false
        self.bio = dict["bio"] as? String ?? ""
        
        self.coord_x = Float(dict["coord_x"] as? Double ?? Double(UserModel.defaultCoordinate))
        self.coord_y = Float(dict["coord_y"] as? Double ?? Double(UserModel.defaultCoordinate))
      
        self.likedDesigns = dict["likedDesigns"] as? [String] ?? []
        self.likedDesignsCount = dict["likedDesignsCount"] as? Int ?? 0
        self.followedArtists = dict["followedArtists"] as? [String] ?? []
        self.followedArtistsCount = dict["followedArtistsCount"] as? Int ?? 0
        self.followers = dict["followers"] as? [String] ?? []
        self.followersCount = dict["followersCount"] as? Int ?? 0
        self.profilePictureURL = URL(string: dict["profilePictureURL"] as? String ?? UserModel.defaultImageURL)!
    }
}

// Define default coordinate value
extension UserModel {
    
    static var defaultCoordinate: Float {
        return -1000
    }
    
    static var defaultImageURL: String {
        return "https://static.vecteezy.com/system/resources/previews/020/911/740/non_2x/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png"
    }
}
