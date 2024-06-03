//
//  GetAllFollowedArtistsUserUseCase.swift
//  InkWay
//
//  Created by Matěj Konopík on 02.06.2024.
//

import Foundation

class GetAllFollowedArtistsUserUseCase: UseCase {
    typealias Input = None
    typealias Output = [UserModel]
    
    private let userRepository: UserRepository
    private let fetchUserWithIdUseCase: FetchUserWithIdUseCase
    
    init(userRepository: UserRepository, fetchUserWithIdUseCase: FetchUserWithIdUseCase) {
        self.userRepository = userRepository
        self.fetchUserWithIdUseCase = fetchUserWithIdUseCase
    }
    
    func execute(with input: None) async throws -> [UserModel] {
        let followedArtists = try await userRepository.getAllFollowedArtists()
        var followedArtistsWithProfilePictures: [UserModel] = []
        
        for artist in followedArtists {
            let artistWithProfilePicture = try await fetchUserWithIdUseCase.execute(with: artist.id)
            followedArtistsWithProfilePictures.append(artistWithProfilePicture)
        }
        
        return followedArtistsWithProfilePictures
    }
}
