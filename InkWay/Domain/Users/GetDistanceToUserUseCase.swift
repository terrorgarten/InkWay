//
//  GetDistanceToUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 03.06.2024.
//

import Foundation

class GetDistanceToUserUseCase: UseCase {
    typealias Input = UserModel
    typealias Output = Double
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: UserModel) async throws -> Double {
        return try await userRepository.getDistanceToUser(with: input)
    }
}
