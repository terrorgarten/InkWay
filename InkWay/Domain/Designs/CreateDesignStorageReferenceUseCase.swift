//
//  CreateDesignStorageReferenceUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import Foundation
import FirebaseStorage

class CreateDesignStorageReferenceUseCase {
    typealias Input = String
    typealias Output = StorageReference
    
    private let designsRepository: DesignsRepository
    
    init(designsRepository: DesignsRepository) {
        self.designsRepository = designsRepository
    }
    
    func execute(with input: String) -> StorageReference {
        return designsRepository.createDesignStorageReference(uuid: input)
    }
}

