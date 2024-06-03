//
//  AddLikedDesignUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 14.05.2024.
//

import Foundation

class AddLikedDesignUserUseCase: UseCase {

    typealias Input = String
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: String) async throws -> None {
        try await userRepository.addUserLikedDesign(with: input)
    }
}
