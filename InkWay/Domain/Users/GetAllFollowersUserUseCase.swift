//
//  GetAllFollowersUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 02.06.2024.
//

import Foundation

class GetAllFollowersUserUseCase: UseCase {
    typealias Input = None
    typealias Output = [UserModel]
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: None) async throws -> [UserModel] {
        return try await userRepository.getAllFollowers()
    }
}
