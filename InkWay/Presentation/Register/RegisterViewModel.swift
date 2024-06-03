//
//  RegisterViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation
import UIKit
import GoogleSignIn

// MARK: Handle registration
class RegisterViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var errorMessage: String? = nil
    @Published var isTermsAccepted: Bool = false
    @Published var navigateToPath: Destination? = nil
    
    private let registerNewUserUseCase = RegisterNewUserUseCase(userRepository: UserRepositoryImpl())
    private let signInWithGoogleUserUseCase = SignInWithGoogleUserUseCase(userRepository: UserRepositoryImpl())
    private let userRepository = UserRepositoryImpl()
    
    func register() {
        guard validate() else {
            return
        }
        Task {
            do {
                //
                let userId = try await registerNewUserUseCase.execute(with: .init(email: email, password: password))
                
                if UserDefaults.standard.bool(forKey: "createTattooerProfile") {
                    await MainActor.run {
                        navigateToPath = .createUserProfile(isArtist: true, id: userId, email: email)
                    }
                
                } else {
                    await MainActor.run {
                        navigateToPath = .createUserProfile(isArtist: false, id: userId, email: email)
                    }
                }
            }
            catch(let error) {
                await MainActor.run {
                    switch(error) {
                    case UserRepositoryError.registerFailed:
                        errorMessage = "Registration failed, try again."
                    default:
                        errorMessage = "Something went wrong, try again."
                    }
                }
            }
        }
    }
    
    func signInWithGoogle() -> Void {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("Could not find any rootViewController in current window.")
            errorMessage = "Google sign in failed."
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
                
                let (userExists, userModel) = try await signInWithGoogleUserUseCase.execute(with: .init(IDTokenString: IDToken.tokenString, acessTokenString: accessToken.tokenString))
                
                if userExists {
                    await MainActor.run {
                        navigateToPath = .home
                    }
                } else {
                    await MainActor.run {
                        if UserDefaults.standard.bool(forKey: "createTattooerProfile") {
                            navigateToPath = .createUserProfile(isArtist: true, id: userModel!.id, email: userModel!.email)
                        } else {
                            navigateToPath = .createUserProfile(isArtist: false, id: userModel!.id, email: userModel!.email)
                        }
                    }
                }
            } catch(let error) {
                await MainActor.run {
                    switch(error) {
                    case UserRepositoryError.googleSignInFailed:
                        errorMessage = "Google login failed."
                    default:
                        errorMessage = "Something went wrong, try again."
                    }
                }
            }
        }
    }
    
    private func validate() -> Bool {
        errorMessage = nil
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter valid email."
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
            errorMessage = "Please accept Terms & Conditions"
            return false
        }
    return true
    }
    
}
