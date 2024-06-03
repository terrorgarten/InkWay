//
//  GetFollowerCountUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 02.06.2024.
//

import Foundation

class GetFollowerCountUserUseCase: UseCase {
    typealias Input = None
    typealias Output = Int
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: None) async throws -> Int {
        return try await userRepository.getFollowerCount()
    }
}
