//
//  SignInUser.swift
//  InkWay
//
//  Created by Oliver Bajus on 17.04.2024.
//

import Foundation

class SignInUserUseCase: UseCase {
    typealias Input = Params
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: Params) async throws -> None {
        return try await userRepository.signIn(with: input.email, password: input.password)
    }
    
    struct Params {
        var email: String
        var password: String
    }
}
