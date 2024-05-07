//
//  UserDetailViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation

class UserDetailViewModel : ObservableObject {
    @Published var posts: [PostModel]? = nil
    @Published var user: UserModel
    
    private let getArtistDesignsUseCase = GetArtistDesignsUseCase(designsRepository: DesignRepositoryImpl())
    private let getPostsUseCase = GetPostsUseCase(fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()))
    
    init(userModel: UserModel) {
        self.user = userModel
    }
    
    func handleFollowAction(following: Bool) {
        // TODO hanle follow action
    }
    
    func fetchUserInfo() {
        Task {
            do {
                let resultDesigns = try await getArtistDesignsUseCase.execute(with: user.id)
                let resultPosts = try await getPostsUseCase.execute(with: resultDesigns)
                await MainActor.run {
                    posts = resultPosts
                }
            }
            catch {
                
            }
        }
    }
}
