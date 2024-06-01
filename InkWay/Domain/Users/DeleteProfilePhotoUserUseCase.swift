//
//  DeleteProfilePhotoUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 14.05.2024.
//

import Foundation

class DeleteProfilePhotoUserUseCase: UseCase {
    
    typealias Input = None
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: None) async throws -> None {
        try await userRepository.removeProfilePicture()
    }
}
