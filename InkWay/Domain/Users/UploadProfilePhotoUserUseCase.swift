//
//  UploadProfilePhotoUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 14.05.2024.
//

import Foundation
import UIKit

class UploadProfilePhotoUserUseCase: UseCase {
    
    typealias Input = UIImage
    typealias Output = URL
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func execute(with input: UIImage) async throws -> URL {
        try await userRepository.uploadProfilePicture(image: input)
    }
}
