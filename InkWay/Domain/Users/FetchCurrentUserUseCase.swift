//
//  FetchCurrentUserUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation

class FetchCurrentUserUseCase: UseCase {
    typealias Input = None
    typealias Output = UserModel
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: None) async throws -> UserModel {
        return try await userRepository.getUser(with: input)
    }
}

