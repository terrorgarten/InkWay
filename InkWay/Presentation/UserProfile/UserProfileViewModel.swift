//
//  UserProfileViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import CoreLocation
import SwiftUI
import PhotosUI

// MARK: Handle user profile viewing and change propagation
class UserProfileViewModel: ObservableObject {
    
    @Published var user: UserModel? = nil
    @Published var errorMsg: String? = ""
    @Published var cityName: String = ""
    @Published var likedPosts: [PostModel] = []
    @Published var likedPostCount: Int = 0
    @Published var followedArtits: [UserModel] = []
    @Published var followedArtitsCount: Int = 0
    @Published var followers: [UserModel] = []
    @Published var followersCount: Int = 0
    
    
    // Use cases
    private let fetchCurrentUserUseCase = FetchCurrentUserUseCase(userRepository: UserRepositoryImpl())
    private let updateUserUseCase = UpdateUserUseCase(userRepository: UserRepositoryImpl())
    
    private let getAllUserLikedPostsUseCase = GetAllUserLikedPostsUserUseCase(userRepository: UserRepositoryImpl(), fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()))
    
    private let getAllFollowedArtistsUseCase = GetAllFollowedArtistsUserUseCase(userRepository: UserRepositoryImpl(), fetchUserWithIdUseCase: FetchUserWithIdUseCase(userRepository: UserRepositoryImpl()))
    
    
    private let getAllFollowersUserUseCase = GetAllFollowersUserUseCase(userRepository: UserRepositoryImpl())
    private let signOutUseCase = SignOutUserUseCase(userRepository: UserRepositoryImpl())
    
    private let deleteProfilePictureUseCase = DeleteProfilePhotoUserUseCase(userRepository: UserRepositoryImpl())
    private let updateProfilePictureUseCase = UploadProfilePhotoUserUseCase(userRepository: UserRepositoryImpl())
    
    
    // logout with Firebase
    func logout() {
        Task {
            do {
                try await _ = signOutUseCase.execute(with: None())
            } catch {
                await MainActor.run {
                    self.errorMsg = "Can't sign out. Try again."
                }
                print("Error signing out")
            }
        }
    }
    
    func loadUserProfile() {
        Task {
            do {
                print("Loading user profile")
                let user = try await self.fetchCurrentUserUseCase.execute(with: None())
                
                // Get the user location
                if user.coord_x == UserModel.defaultCoordinate && user.coord_y == UserModel.defaultCoordinate {
                    await MainActor.run {
                        self.cityName = ""
                    }
                } else {
                    await MainActor.run {
                        self.reverseGeocode(x_coord: user.coord_x, y_coord: user.coord_y)
                    }
                }
                
                let likedPosts = try await self.getAllUserLikedPostsUseCase.execute(with: None())
                let followedArtists = try await self.getAllFollowedArtistsUseCase.execute(with: None())
                
                await MainActor.run {
                    self.user = user
                    self.likedPosts = likedPosts
                    self.followedArtits = followedArtists
                }
                
                if user.artist {
                    // Get followers
                    let followers = try await self.getAllFollowersUserUseCase.execute(with: None())
                    await MainActor.run {
                        self.followers = followers
                    }
                }
                print("User profile loaded")

            } catch {
                errorMsg = "Can't load user profile. Try again."
                print("Error loading user profile")
            }
        }
    }
    
    func updateUserProfile(user: UserModel) {
        Task {
            do {
                _ = try await updateUserUseCase.execute(with: user)
                
                if user.coord_x == UserModel.defaultCoordinate && user.coord_y == UserModel.defaultCoordinate {
                    await MainActor.run {
                        self.cityName = ""
                    }
                } else {
                    await MainActor.run {
                        self.reverseGeocode(x_coord: user.coord_x, y_coord: user.coord_y)
                    }
                }
                
            } catch {
                errorMsg = "Can't update. Try again."
                print("Error updating user profile")
            }
        }
        self.user = user
    }
    
    func deleteProfilePicture() {
        print("Deleting profile picture")
        Task {
            do {
                _ = try await deleteProfilePictureUseCase.execute(with: None())
            } catch {
                errorMsg = "Delete failed. Try again."
                print("Error deleting profile picture")
            }
        }
        self.user?.profilePictureURL = URL(string: UserModel.defaultImageURL)!
    }
    
    func updateProfilePicture(image: UIImage) {
        print("Updating profile picture")
        Task {
            do {
                let newPictureURL = try await updateProfilePictureUseCase.execute(with: image)
                await MainActor.run {
                    self.user?.profilePictureURL = newPictureURL
                }
            } catch {
                errorMsg = "Upload failed. Try again."
                print("Error uploading profile picture")
            }
        }
    }

    // get city from x y coords
    private func reverseGeocode(x_coord: Float, y_coord: Float) {
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(x_coord), longitude: CLLocationDegrees(y_coord))
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { [weak self] placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                self?.cityName = ""
                return
            }
            
            DispatchQueue.main.async {
                self?.cityName = placemark.locality ?? ""
            }
        }
    }
    
}

// MARK: ImagePicker for user profile pictures
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
}
