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
    private let getAllUserLikedPostsUserUseCase: GetAllUserLikedPostsUserUseCase
    
    init(fetchUserWithIdUseCase: FetchUserWithIdUseCase, getAllUserLikedPostsUserUseCase: GetAllUserLikedPostsUserUseCase) {
        self.fetchUserWithIdUseCase = fetchUserWithIdUseCase
        self.getAllUserLikedPostsUserUseCase = getAllUserLikedPostsUserUseCase
    }
    
    func execute(with input: [DesignModel]) async throws -> [PostModel] {
        var resultPosts: [PostModel] = []
        let userLikedDesigns = try await getAllUserLikedPostsUserUseCase.execute(with: None())
        for design in input {
            var isLiked = false
            let artist = try await fetchUserWithIdUseCase.execute(with: design.userId)
            if userLikedDesigns.contains(where: { $0.design.id == design.id }) {
                print("Design \(design.id) is liked")
                isLiked = true
            }
            resultPosts.append(PostModel(design: design, artist: artist, isLiked: isLiked))
        }
        return resultPosts
    }
}

