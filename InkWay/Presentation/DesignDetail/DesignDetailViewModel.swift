//
//  DesignDetailViewModel.swift
//  InkWay
//
//  Created by Oliver Bajus on 26.04.2024.
//

import Foundation

class DesignDetailViewModel : ObservableObject {
    @Published var post: PostModel
    
    private let addLikedDesignUseCase = AddLikedDesignUserUseCase(userRepository: UserRepositoryImpl())
    private let getLikedDesignsUseCase = GetAllUserLikedPostsUserUseCase(userRepository: UserRepositoryImpl(), fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()))
    private let removeLikedDesignUseCase = RemoveLikedDesignUserUseCase(userRepository: UserRepositoryImpl())
    
    init(postModel: PostModel) {
        self.post = postModel
        resolveLikeState()
    }
    
    // Considering state before user pressed the like button
    func handleLikeAction() {
        if !post.isLiked {
            Task {
                do {
                    // Previously not liked, so like it
                    _ = try await addLikedDesignUseCase.execute(with: self.post.design.id.uuidString)
                    await MainActor.run {
                        post.isLiked = true
                    }
                }
                catch {
                    print("Error")
                }
            }
        } else {
            Task {
                do {
                    // Previously liked, so unlike it
                    _ = try await removeLikedDesignUseCase.execute(with: self.post.design.id.uuidString)
                    await MainActor.run {
                        post.isLiked = false
                    }
                }
                catch {
                    
                }
            }
        }
    }
    
    func resolveLikeState() {
        Task {
            do {
                let userLikedPosts = try await getLikedDesignsUseCase.execute(with: None())
                await MainActor.run {
                    post.isLiked = userLikedPosts.contains(where: { $0.design.id == post.design.id })
                }
            }
            catch {
                
            }
        }
    }

}
