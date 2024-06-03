//
//  SignUpWithGoogleUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 14.05.2024.
//

import Foundation

class SignUpWithGoogleUserUseCase: UseCase {
    typealias Input = Params
    typealias Output = UserModel
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: Params) async throws -> UserModel {
        return try await userRepository.signUpWithGoogle(with: input.IDTokenString, accessTokenString: input.accessTokenString)
    }
    
    struct Params {
        var IDTokenString: String
        var accessTokenString: String
    }
}
