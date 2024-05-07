//
//  FetchUserWithId.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import Foundation

class FetchUserWithIdUseCase: UseCase {
    typealias Input = String
    typealias Output = UserModel
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: String) async throws -> UserModel {
        return try await userRepository.fetchUserWithId(with: input)
    }
}
