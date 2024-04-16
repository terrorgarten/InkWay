//
//  FetchCurrentUserUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation


// TODO - just example
class FetchCurrentUserUseCase: UseCase {
    typealias Input = None
    typealias Output = UserModel
    
    let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: None) async throws -> UserModel {
        return try await userRepository.getUser(with: input)
    }
}

