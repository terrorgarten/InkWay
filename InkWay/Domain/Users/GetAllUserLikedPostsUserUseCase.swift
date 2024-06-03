//
//  GetAllUserLikedPostsUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 02.06.2024.
//

import Foundation

class GetAllUserLikedPostsUserUseCase: UseCase {
    typealias Input = None
    typealias Output = [PostModel]
    
    private let userRepository: UserRepository
    private let fetchUserWithIdUseCase: FetchUserWithIdUseCase
    
    init(userRepository: UserRepository, fetchUserWithIdUseCase: FetchUserWithIdUseCase) {
        self.userRepository = userRepository
        self.fetchUserWithIdUseCase = fetchUserWithIdUseCase
    }
    
    func execute(with input: None) async throws -> [PostModel] {
        let likedDesigns = try await userRepository.getAllUserLikedDesigns()
        // turn designs into posts
        var likedPosts: [PostModel] = []
        for design in likedDesigns {
            let artist = try await fetchUserWithIdUseCase.execute(with: design.userId)
            likedPosts.append(PostModel(design: design, artist: artist))
        }
        return likedPosts
    }
}
