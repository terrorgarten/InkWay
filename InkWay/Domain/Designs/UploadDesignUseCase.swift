//
//  UploadDesignUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 06.05.2024.
//

import Foundation
import UIKit
import FirebaseStorage

class UploadDesignUseCase: UseCase {
    typealias Input = Params
    typealias Output = None
    
    private let designsRepository: DesignsRepository
    
    init(designsRepository: DesignsRepository) {
        self.designsRepository = designsRepository
    }
    
    func execute(with input: Params) async throws -> None {
        return try await designsRepository.uploadDesign(with: input)
    }
    
    func createDesignStorageReference(uuid: UUID, image: UIImage) -> StorageReference {
        return Storage.storage().reference().child("designs/\(uuid.uuidString).jpg")
    }
    
    struct Params {
        let id: UUID
        let imageUrl: URL
        let description: String
        let tags: [String]
        let name: String
        let price: Int
    }
}
