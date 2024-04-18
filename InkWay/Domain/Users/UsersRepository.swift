//
//  UsersRepository.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation

// TODO - just example
protocol UserRepository {
    func getUser(with input: None) async throws -> UserModel
    func signIn(with email: String, password: String) async throws -> None
    func register(with email: String, password: String) async throws -> None
}