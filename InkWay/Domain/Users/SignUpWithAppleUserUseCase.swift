//
//  SignUpWithAppleUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 14.05.2024.
//

import Foundation

class SignUpWithAppleUserUseCase: UseCase {
    typealias Input = Params
    typealias Output = UserModel
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: Params) async throws -> UserModel {
        return try await userRepository.signUpWithApple(with: input.IDToken, rawNonce: input.rawNonce, fullName: input.fullName)
    }
    
    struct Params {
        var IDToken: String
        var rawNonce: String
        var fullName: PersonNameComponents?
    }
}
