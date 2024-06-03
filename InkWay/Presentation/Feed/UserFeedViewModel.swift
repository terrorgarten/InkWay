//
//  UserFeedViewModel.swift
//  InkWay
//
//  Created by Adam Valent on 24/04/2024.
//

import Foundation
import SwiftUI
import CoreLocation

class UserFeedViewModel : ObservableObject {
    @Published var searchText: String = ""
    @Published var selectedFeed = 0
    @Published var followingPosts: [PostModel] = []
    @Published var nearmePosts: [PostModel] = []
    @Published var isLoading: Bool = false
    
    private let locationManager = CLLocationManager()
    private let getLikedDesignsUseCase = GetAllUserLikedPostsUserUseCase(userRepository: UserRepositoryImpl(), fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()))
    private let addLikedDesignUseCase = AddLikedDesignUserUseCase(userRepository: UserRepositoryImpl())
    private let removeLikedDesignUseCase = RemoveLikedDesignUserUseCase(userRepository: UserRepositoryImpl())
    private let getAllDesignsUseCase = GetAllDesignsUseCase(designsRepository: DesignRepositoryImpl())
    private let getAllPostsUseCase = GetPostsUseCase(fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()), getAllUserLikedPostsUserUseCase: GetAllUserLikedPostsUserUseCase(userRepository: UserRepositoryImpl(), fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl())))
    
    var followingPostsInitValue: [PostModel] = []
    var nearmePostsInitValue: [PostModel] = []
    let feedTypes: [String] = ["Near me", "Following"]
    
    func fetchPosts() {
        print("fetching posts")
        isLoading = true
        Task {
            do {
                let resultDesigns = try await self.getAllDesignsUseCase.execute(with: None())
                let resultPosts = try await self.getAllPostsUseCase.execute(with: resultDesigns)
                
                let postsCopy = resultPosts
                
                await MainActor.run {
                    // TODO filter following and near by posts
                    self.followingPosts = postsCopy
                    self.followingPostsInitValue = postsCopy
                    self.nearmePosts = postsCopy
                    self.nearmePostsInitValue = postsCopy
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func filterPostsByFlags(selectedTags: [Tag]) {
        Task {
            await MainActor.run {
                if selectedTags.isEmpty {
                    self.followingPosts = self.followingPostsInitValue
                    self.nearmePosts = self.nearmePostsInitValue
                    return
                }
                self.followingPosts = self.followingPostsInitValue.filter { post in
                    post.design.tags.contains { tag in
                        selectedTags.contains { $0.text == tag }
                    }
                }
                self.nearmePosts = self.nearmePostsInitValue.filter { post in
                    post.design.tags.contains { tag in
                        selectedTags.contains { $0.text == tag }
                    }
                }
            }
        }
    }
    
    func handleLikeAction(isLiked: Bool, designId: String) {
        if (isLiked) {
            unlikePost(designId: designId)
        } else {
            likePost(designId: designId)
        }
    }

    func likePost(designId: String) {
        Task {
            do {
                _ = try await addLikedDesignUseCase.execute(with: designId)
            } catch {
                print("Error liking post")
            }
        }
    }

    func unlikePost(designId: String) {
        Task {
            do {
                _ = try await removeLikedDesignUseCase.execute(with: designId)
            } catch {
                print("Error unliking post")
            }
        }
    }
    
    func filterPostsByDistance(distance: Double) {
        nearmePosts = nearmePosts.filter { post in
            distance > calculateDistanceFromMyLocation(post.artist)
        }
    }
    
    func calculateDistanceFromMyLocation(_ coordinates: UserModel) -> Double {
        guard let locValue: CLLocationCoordinate2D = locationManager.location?.coordinate else { return 0 }
        let deltaX = coordinates.coord_x - Float(locValue.longitude)
        let deltaY = coordinates.coord_y - Float(locValue.latitude)
        return Double(sqrt(deltaX * deltaX + deltaY * deltaY))
    }
}
