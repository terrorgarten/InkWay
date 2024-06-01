//
//  UsersRepository.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation
import UIKit

protocol UserRepository {
    func getUser() async throws -> UserModel
    func logOut() throws -> None
    
    func signIn(with email: String, password: String) async throws -> None
    func register(with email: String, password: String) async throws -> None
    
    func signInWithApple(with IDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> (Bool, UserModel?)
    func signUpWithApple(with IDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> UserModel
    func signInWithGoogle(with IDTokenString: String, accessTokenString: String) async throws -> (Bool, UserModel?)
    func signUpWithGoogle(with IDTokenString: String, accessTokenString: String) async throws -> UserModel
    
    func addUserLikedDesign(with designId: String) async throws -> None
    func removeUserLikedDesign(with designId: String) async throws -> None
    
    func updateUserProfile(with userModel: UserModel) async throws -> None
    
    func uploadProfilePicture(image: UIImage) async throws -> URL
    func removeProfilePicture() async throws -> None

}
