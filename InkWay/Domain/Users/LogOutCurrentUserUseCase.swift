//
//  LogOutCurrentUserUseCase.swift
//  InkWay
//
//  Created by terrorgarten on 10.05.2024.
//

import Foundation

class LogOutCurrentUserUseCase: UseCase {
    
    typealias Input = None
    typealias Output = None
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: None) throws -> None {
        try userRepository.logOut()
    }
}
