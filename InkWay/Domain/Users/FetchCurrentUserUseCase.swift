//
//  FetchCurrentUserUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation

class FetchUserDataUseCase: UseCase {
    typealias Input = Void
    typealias Output = String
    
    let userRepository: UserRepository
    let userID: String
    
    init(userRepository: UserRepository, userID: String) {
        self.userRepository = userRepository
        self.userID = userID
    }
    
    func execute(with input: Void) async throws -> String {
        <#code#>
    }
}

