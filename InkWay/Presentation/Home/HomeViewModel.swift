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
            // TODO - fix, returns -> '10.24.0 - [FirebaseFirestore][I-FST000001] Listen for query at users/9EoqC2umhJSvSHeVw0pDuKBfKws2 failed: Missing or insufficient permissions.'
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
