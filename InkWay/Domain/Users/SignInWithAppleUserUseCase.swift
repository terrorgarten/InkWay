//
//  SignInWithAppleUserUseCase.swift
//  InkWay
//
//  Created by terrorgarten on 25.04.2024.
//

import Foundation

class SignInWithAppleUserUseCase: UseCase {
    typealias Input = Params
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: Params) async throws -> None {
        return try await userRepository.signInWithApple(with: input.IDToken, rawNonce: input.rawNonce, fullName: input.fullName)
    }
    
    struct Params {
        var IDToken: String
        var rawNonce: String
        var fullName: PersonNameComponents?
    }
}
