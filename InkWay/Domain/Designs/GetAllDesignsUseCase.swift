//
//  GetAllDesignsUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import Foundation

class GetAllDesignsUseCase: UseCase {
    typealias Input = None
    typealias Output = [DesignModel]
    
    private let designsRepository: DesignsRepository
    
    init(designsRepository: DesignsRepository) {
        self.designsRepository = designsRepository
    }
    
    func execute(with input: None) async throws -> [DesignModel] {
        return try await designsRepository.getAllDesigns()
    }
}
