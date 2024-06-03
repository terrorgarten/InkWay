//
//  SignOutUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 03.06.2024.
//

import Foundation

class SignOutUserUseCase: UseCase {
    typealias Input = None
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: None) async throws -> None {
        _ = try await userRepository.signOut(with: None())
        return None()
    }
}
