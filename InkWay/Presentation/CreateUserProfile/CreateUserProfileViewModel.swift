//
//  CreateUserProfileViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 10.05.2024.
//

import Foundation
import SwiftUI

class CreateUserViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var name: String = ""
    @Published var surname: String = ""
    @Published var instagram: String? = ""
    @Published var profileImage: Image? = nil
    @Published var errorMessage: String? = nil
    
    // private var createUserUseCase = CreateUserUseCase(userRepository: UserRepositoryImpl())

    func createUserProfile() {
        guard validateInputs() else { return }
        
        Task {
            do {
                let _ = UserModel(id: UUID().uuidString, username: username, profilePicture: "", name: name, surename: surname, instagram: instagram ?? "", email: 	"", joined: Date().timeIntervalSince1970, likedDesigns: [], artist: false)
                // _ = try await createUserUseCase.execute(user: userModel)
                // TODO handle success - navigate away or show success message..
            } catch {
                self.errorMessage = "Failed to create user profile. Please try again."
            }
        }
    }

    private func validateInputs() -> Bool {
        if username.isEmpty || name.isEmpty || surname.isEmpty {
            errorMessage = "All fields are required. Please fill them in."
            return false
        }
        return true
    }
}
