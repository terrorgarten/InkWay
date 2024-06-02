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
    private let getAllDesignsUseCase = GetAllDesignsUseCase(designsRepository: DesignRepositoryImpl())
    private let getAllPostsUseCase = GetPostsUseCase(fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()))
    
    var followingPostsInitValue: [PostModel] = []
    var nearmePostsInitValue: [PostModel] = []
    let feedTypes: [String] = ["Near me", "Following"]
    
    func fetchPosts() {
    isLoading = true
        Task {
            do {
                let resultDesigns = try await getAllDesignsUseCase.execute(with: None())
                let resultPosts = try await getAllPostsUseCase.execute(with: resultDesigns)
                await MainActor.run {
                    // TODO filter following and near by posts
                    followingPosts = resultPosts
                    followingPostsInitValue = resultPosts
                    nearmePosts = resultPosts
                    nearmePostsInitValue = resultPosts
                    isLoading = false
                }
            }
            catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
    
    func filterPostsByFlags(selectedTags: [Tag]) {
        if selectedTags.isEmpty {
            followingPosts = followingPostsInitValue
            nearmePosts = nearmePostsInitValue
            return
        }
        followingPosts = followingPostsInitValue.filter { post in
            post.design.tags.contains { tag in
                selectedTags.contains { $0.text == tag }
            }
        }
        nearmePosts = nearmePostsInitValue.filter { post in
            post.design.tags.contains { tag in
                selectedTags.contains { $0.text == tag }
            }
        }
    }
    
    func filterPostsByDistance(distance: Double){
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
