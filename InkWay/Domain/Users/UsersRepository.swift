//
//  UsersRepository.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation
import UIKit

// TODO - just example
protocol UserRepository {
    
    // Current user
    func getUser(with input: None) async throws -> UserModel
    
    // Getting other users
    func fetchUserWithId(with id: String) async throws -> UserModel
    
    func getDistanceToUser(with input: UserModel) async throws -> Double
    
    // Creating users
    func createUserProfile(with user: UserModel) async throws -> None
    
    // Basic email user auth
    func signIn(with email: String, password: String) async throws -> None
    func signOut(with input: None) async throws -> None
    func register(with email: String, password: String) async throws -> String

    
    
    // user OAuth
    func signInWithApple(with IDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> (Bool, UserModel?)
    func signUpWithApple(with IDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> UserModel
    func signInWithGoogle(with IDTokenString: String, accessTokenString: String) async throws -> (Bool, UserModel?)
    func signUpWithGoogle(with IDTokenString: String, accessTokenString: String) async throws -> UserModel

    // Liked designs
    func addUserLikedDesign(with designId: String) async throws -> None
    func removeUserLikedDesign(with designId: String) async throws -> None
    func getAllUserLikedDesigns() async throws -> [DesignModel]
    func getLikedDesignsCount() async throws -> Int
    
    // User profile management
    func updateUserProfile(with userModel: UserModel) async throws -> None

    // Profile picture management
    func uploadProfilePicture(image: UIImage) async throws -> URL
    func removeProfilePicture() async throws -> None
    
    // Social
    func getAllFollowedArtists() async throws -> [UserModel]
    func getFollowedArtistCount() async throws -> Int
    
    func getAllFollowers() async throws -> [UserModel]
    func getFollowerCount() async throws -> Int
    
    func followArtist(with artistId: String) async throws -> None
    func unfollowArtist(with artistId: String) async throws -> None
    
}
