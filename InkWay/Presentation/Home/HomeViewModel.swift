//
//  HomeViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 16.04.2024.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var currentUserId: String
    @Published var currentUserArtistStatus: Bool
    private var fetchCurrentUserUseCase: FetchCurrentUserUseCase = FetchCurrentUserUseCase(userRepository: UserRepositoryImpl())
    
    init(currentUserId: String, currentUserArtistStatus: Bool) {
        self.currentUserId = currentUserId
        self.currentUserArtistStatus = currentUserArtistStatus
        Task {
            do {
                var a = try await fetchCurrentUserUseCase.execute(with: None())
                print(a)
            }
            catch(let error){
                print(error)
            }
        }
    }
 
}
