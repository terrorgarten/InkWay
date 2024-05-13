//
//  RegisterViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation
import SwiftUI
import AuthenticationServices
import GoogleSignIn

class RegisterViewModel: ObservableObject {
    @Published var errorMessage: String? = nil
    @Published var navigateToPath: Destination? = nil
    @Published var tempUserData: UserModel?
    @Published var isArtist: Bool = false
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var isTermsAccepted: Bool = false

    private let userRepository = UserRepositoryImpl()
    private let signInWithGoogleUserUseCase = SignInWithGoogleUserUseCase(userRepository: UserRepositoryImpl())

    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            errorMessage = "Unable to access the window scene for Google sign-in."
            return
        }

        Task {
            do {
                let userAuth = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                let user = userAuth.user
                guard let IDToken = user.idToken else {
                    throw UserRepositoryError.googleSignInFailed
                }
                let accessToken = user.accessToken
                
                let signInParams = SignInWithGoogleUserUseCase.Params(IDTokenString: IDToken, accessTokenString: accessToken)
                try await signInWithGoogleUserUseCase.execute(with: signInParams)
                
                prepareTempUserData(id: user.userID ?? "", email: user.profile?.email ?? "", profilePictureURL: user.profile?.imageURL(withDimension: 200)?.absoluteString ?? "", name: user.profile?.givenName ?? "", surname: user.profile?.familyName ?? "")
                await navigateToProfileCompletion()
            } catch {
                await MainActor.run {
                    switch(error) {
                    case UserRepositoryError.googleSignInFailed:
                        self.errorMessage = "Google login failed."
                    default:
                        self.errorMessage = "Something went wrong, try again."
                    }
                }
            }
        }
    }

    func signInWithApple(IDToken: String, rawNonce: String, fullName: PersonNameComponents?) {
        Task {
            do {
                try await userRepository.signInWithApple(with: IDToken, rawNonce: rawNonce, fullName: fullName)
                if let fullName = fullName {
                    prepareTempUserData(id: "", email: "", profilePictureURL: "", name: fullName.givenName ?? "", surname: fullName.familyName ?? "")
                }
                await navigateToProfileCompletion()
            } catch {
                await MainActor.run {
                    self.errorMessage = "Apple Sign In failed: \(error.localizedDescription)"
                }
            }
        }
    }

    func registerWithEmail() {
        guard validateCredentials() else {
            return
        }
        Task {
            do {
                try await userRepository.register(with: email, password: password)
                await navigateToProfileCompletion()
            } catch {
                await MainActor.run {
                    self.errorMessage = "Registration failed: \(error.localizedDescription)"
                }
            }
        }
    }

    private func validateCredentials() -> Bool {
        errorMessage = nil
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email."
            return false
        }
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 letters."
            return false
        }
        guard password == passwordConfirm else {
            errorMessage = "The passwords do not match."
            return false
        }
        guard isTermsAccepted else {
            errorMessage = "Please accept the Terms & Conditions."
            return false
        }
        return true
    }
    
    func navigateToProfileCompletion() {
        if self.isArtist {
            navigateToPath = .createArtistProfile
        } else {
            navigateToPath = .createUserProfile
        }
    }
}
