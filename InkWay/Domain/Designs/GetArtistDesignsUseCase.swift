//
//  GetArtistDesigns.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import Foundation

class GetArtistDesignsUseCase: UseCase {
    typealias Input = String
    typealias Output = [DesignModel]
    
    private let designsRepository: DesignsRepository
    
    init(designsRepository: DesignsRepository) {
        self.designsRepository = designsRepository
    }
    
    func execute(with input: String) async throws -> [DesignModel] {
        return try await designsRepository.getUserDesigns(userId: input)
    }
}

