//
//  UserDetailViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation

class UserDetailViewModel : ObservableObject {
    @Published var designs: [PostModel]? = nil
    @Published var user: UserModel? = nil
    private let userId: String
    private let fetchCurrentUserUseCase = FetchCurrentUserUseCase(userRepository: UserRepositoryImpl())
    
    init(userId: String) {
        self.userId = userId
    }
    
    func fetchUser() {
        // TODO - fetch user
        Task {
            do {
                let fetchedUser = try await fetchCurrentUserUseCase.execute(with: None())
                await MainActor.run {
                    user = fetchedUser
                }
            }
            catch {
                
            }
        }
    }
    
    func handleFollowAction(following: Bool) {
        
    }
}
