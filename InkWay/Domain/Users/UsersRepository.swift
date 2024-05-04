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
    func getUser(with input: None) async throws -> UserModel
    func signIn(with email: String, password: String) async throws -> None
    func register(with email: String, password: String) async throws -> None
    func signInWithApple(with IDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> None
    func signInWithGoogle(with IDTokenString: String, accessTokenString: String) async throws -> None
}
