//
//  RemoveLikedDesignUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 14.05.2024.
//

import Foundation

class RemoveLikedDesignUserUseCase: UseCase {
    
    typealias Input = String
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: String) async throws -> None {
        try await userRepository.removeUserLikedDesign(with: input)
    }
}
