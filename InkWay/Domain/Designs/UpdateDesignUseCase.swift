//
//  UpdateDesignUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import Foundation

class UpdateDesignUseCase: UseCase {
    typealias Input = DesignModel
    typealias Output = DesignModel
    
    private let designsRepository: DesignsRepository
    
    init(designsRepository: DesignsRepository) {
        self.designsRepository = designsRepository
    }
    
    func execute(with input: DesignModel) async throws -> DesignModel {
        return try await designsRepository.updateDesign(designModel: input)
    }
}

