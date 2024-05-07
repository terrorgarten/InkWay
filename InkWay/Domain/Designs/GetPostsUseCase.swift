//
//  GetAllPostsUseCase.swift
//  InkWay
//
//  Created by Oliver Bajus on 07.05.2024.
//

import Foundation

class GetPostsUseCase: UseCase {
    typealias Input = [DesignModel]
    typealias Output = [PostModel]
    
    private let fetchUserWithIdUseCase: FetchUserWithIdUseCase
    
    init(fetchUserWithIdUseCase: FetchUserWithIdUseCase) {
        self.fetchUserWithIdUseCase = fetchUserWithIdUseCase
    }
    
    func execute(with input: [DesignModel]) async throws -> [PostModel] {
        var resultPosts: [PostModel] = []
        for design in input {
            let user = try await fetchUserWithIdUseCase.execute(with: design.userId)
            resultPosts.append(PostModel(design: design, artist: user))
        }
        return resultPosts
    }
}

