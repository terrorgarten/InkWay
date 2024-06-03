//
//  CreateUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 03.06.2024.
//

import Foundation

class CreateUserUseCase: UseCase {
    typealias Input = UserModel
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: UserModel) async throws -> None {
        return try await userRepository.createUserProfile(with: input)
    }

}
