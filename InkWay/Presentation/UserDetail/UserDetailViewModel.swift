    //
    //  UserDetailViewModel.swift
    //  InkWay
    //
    //  Created by Oliver Bajus on 26.04.2024.
    //

import Foundation
import CoreLocation

class UserDetailViewModel : ObservableObject {
    @Published var posts: [PostModel]? = nil
    @Published var user: UserModel
    @Published var userFollows: Bool = false
    @Published var location: String = ""
    
    private let getArtistDesignsUseCase = GetArtistDesignsUseCase(designsRepository: DesignRepositoryImpl())
    private let getPostsUseCase = GetPostsUseCase(fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()), getAllUserLikedPostsUserUseCase: GetAllUserLikedPostsUserUseCase(userRepository: UserRepositoryImpl(), fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl())))
    private let followUserUseCase = FollowArtistUserUseCase(userRepository: UserRepositoryImpl())
    private let unfollowUserUseCase = UnfollowArtistUserUseCase(userRepository: UserRepositoryImpl())
    private let getDistanceToUser = GetDistanceToUserUseCase(userRepository: UserRepositoryImpl())
    private let fetchCurrentUserUseCase = FetchCurrentUserUseCase(userRepository: UserRepositoryImpl())
    
    init(userModel: UserModel) {
        self.user = userModel
    }
    
    func handleFollowAction(following: Bool) {
        Task {
            do {
                if following {
                    _ = try await followUserUseCase.execute(with: user.id)
                    await MainActor.run {
                        self.userFollows = true
                        self.user.followersCount += 1
                    }
                } else {
                    _ = try await unfollowUserUseCase.execute(with: user.id)
                    await MainActor.run {
                        self.userFollows = false
                        self.user.followersCount -= 1
                    }
                }
            }
            catch {
                print("Error following user", error)
            }
        }
    }
    
    func fetchUserInfo() {
        print("Fetching user info")
        Task {
            do {
                let resultDesigns = try await getArtistDesignsUseCase.execute(with: user.id)
                let resultPosts = try await getPostsUseCase.execute(with: resultDesigns)
                let currUser = try await self.fetchCurrentUserUseCase.execute(with: None())
                let userFollows = currUser.followedArtists.contains(self.user.id)
                await MainActor.run {
                    posts = resultPosts
                    self.userFollows = userFollows
                    self.reverseGeocode(x_coord: user.coord_x, y_coord: user.coord_y)
                }
            }
            catch {
                print("Error fetching user info", error)
            }
            
        }
        print("Finished fetching user info")
    }
    
    private func reverseGeocode(x_coord: Float, y_coord: Float) {
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(x_coord), longitude: CLLocationDegrees(y_coord))
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { [weak self] placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                self?.location = ""
                return
            }
            
            DispatchQueue.main.async {
                self?.location = placemark.locality ?? ""
            }
        }
    }
}
