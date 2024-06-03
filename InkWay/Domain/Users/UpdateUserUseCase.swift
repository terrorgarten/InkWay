//
//  UpdateUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 14.05.2024.
//

import Foundation

class UpdateUserUseCase: UseCase {

    typealias Input = UserModel
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: UserModel) async throws -> None {
        try await userRepository.updateUserProfile(with: input)
    }
}
