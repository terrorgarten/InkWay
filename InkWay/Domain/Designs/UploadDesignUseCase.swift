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
    typealias Output = DesignModel
    
    private let designsRepository: DesignsRepository
    
    init(designsRepository: DesignsRepository) {
        self.designsRepository = designsRepository
    }
    
    func execute(with input: Params) async throws -> DesignModel {
        return try await designsRepository.uploadDesign(with: input)
    }
    
    struct Params {
        let id: UUID
        let imageUrl: String
        let description: String
        let tags: [String]
        let name: String
        let price: Int
    }
}
