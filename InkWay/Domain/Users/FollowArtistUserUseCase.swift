//
//  FollowArtistUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 03.06.2024.
//

import Foundation

class FollowArtistUserUseCase: UseCase {
    typealias Input = String
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: String) async throws -> None {
        try await userRepository.followArtist(with: input)
    }
}
