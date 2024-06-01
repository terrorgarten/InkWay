//
//  SignInWithGoogleUserUseCase.swift
//  InkWay
//
//  Created by terrorgarten on 26.04.2024.
//

import Foundation
import UIKit

class SignInWithGoogleUserUseCase: UseCase {
    typealias Input = Params
    typealias Output = (Bool, UserModel?)
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: Params) async throws -> Output {
        return try await userRepository.signInWithGoogle(with: input.IDTokenString, accessTokenString: input.acessTokenString)
    }
    
    struct Params {
        var IDTokenString: String
        var acessTokenString: String
    }
}
