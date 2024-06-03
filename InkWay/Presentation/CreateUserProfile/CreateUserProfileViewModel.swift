//
//  CreateUserProfileViewModel.swift
//  InkWay
//
//  Created by Matěj Konopík on 03.06.2024.
//

import Foundation
import CoreLocation
import SwiftUI
import PhotosUI

class CreateUserProfileViewModel: ObservableObject {
    @Published var isArtist: Bool
    @Published var id: String
    @Published var email: String

    @Published var newUser: UserModel = UserModel(from: [:])
    @Published var name: String = ""
    @Published var surename: String = ""
    @Published var instagram: String = ""
    @Published var joined: TimeInterval = Date().timeIntervalSince1970
    @Published var profilePictureURL: URL = URL(string: UserModel.defaultImageURL)!
    @Published var bio: String = ""
    @Published var coordinates = CLLocationCoordinate2D()
    @Published var coord_x: Float = UserModel.defaultCoordinate
    @Published var coord_y: Float = UserModel.defaultCoordinate
    @Published var error: String?
    @Published var navigateToPath: Destination? = nil

    private let updateProfilePictureUseCase = UploadProfilePhotoUserUseCase(userRepository: UserRepositoryImpl())
    private let createUserUseCase = CreateUserUseCase(userRepository: UserRepositoryImpl())

    init(isArtist: Bool, id: String, email: String) {
        self.isArtist = isArtist
        self.id = id
        self.email = email
    }

    func createUserProfile() {
        guard !name.isEmpty else {
            error = "Please fill your name."
            return
        }

        if coord_x == UserModel.defaultCoordinate && coord_y == UserModel.defaultCoordinate && isArtist {
            error = "Please set your location."
            return
        }

        self.newUser = UserModel(id: id,
                                 name: name,
                                 surename: surename,
                                 instagram: instagram,
                                 email: email,
                                 joined: joined,
                                 artist: isArtist,
                                 bio: bio,
                                 coord_y: coord_y,
                                 coord_x: coord_x,
                                 likedDesigns: [],
                                 likedDesignsCount: 0,
                                 followedArtists: [],
                                 followedArtistsCount: 0,
                                 followers: [],
                                 followersCount: 0,
                                 profilePictureURL: profilePictureURL)

        Task {
            do {
                _ = try await self.createUserUseCase.execute(with: self.newUser)
                await MainActor.run {
                    if UserDefaults.standard.bool(forKey: "showedOnboarding") {
                        navigateToPath = .home
                    } else {
                        navigateToPath = .onboarding
                    }
                }
            } catch {
                self.error = "Can't create account. Try again."
                print("Error creating user profile")
            }
        }
    }
}

