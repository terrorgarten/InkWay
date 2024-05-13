//
//  File.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation
import AuthenticationServices
import GoogleSignIn


// MARK: Login handler
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String? = nil
    @Published var navigateToPath: Destination? = nil
    
    private var currentNonce: String?
    
    private let signInUserUseCase = SignInUserUseCase(userRepository: UserRepositoryImpl())
    private let signInWithAppleUserUseCase = SignInWithAppleUserUseCase(userRepository: UserRepositoryImpl())
    private let signInWithGoogleUserUseCase = SignInWithGoogleUserUseCase(userRepository: UserRepositoryImpl())
    
    // logint user with firebase
    func login() -> Void {
        guard validate() else {
            return
        }
        Task {
            do {
                _ = try await signInUserUseCase.execute(with: .init(email: email, password: password))
                let showedOnboarding = UserDefaults.standard.bool(forKey: "showedOnboarding")
                await MainActor.run {
                    if showedOnboarding {
                        navigateToPath = .home
                    } else {
                        navigateToPath = .onboarding
                    }
                }
            }
            catch(let error) {
                await MainActor.run {
                    switch(error) {
                    case UserRepositoryError.loginFailed:
                        errorMessage = "Invalid credentials."
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
                
                _ = try await signInWithGoogleUserUseCase.execute(with: .init(IDTokenString: IDToken.tokenString, acessTokenString: accessToken.tokenString))
                let showedOnboarding = UserDefaults.standard.bool(forKey: "showedOnboarding")
                await MainActor.run {
                    if showedOnboarding {
                        navigateToPath = .home
                    } else {
                        navigateToPath = .onboarding
                    }
                }
            }
            catch(let error) {
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
    
    // Prepares the request, sets the hashed nonce
    func signInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) -> Void {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString() // From IW CryptoUtils
        currentNonce = nonce
        request.nonce = sha256(nonce) // From IW CryptoUtils
    }
    
    // Called on completion
    func signInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) -> Void {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        }
        else if case .success(let success) = result {
            // Apple internal ID token
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                        fatalError("Invalid state: A login callback was received, but no login request was sent.")
                      }
                      guard let appleIDToken = appleIDCredential.identityToken else {
                        print("Unable to fetch identity token")
                        return
                      }
                      guard let IDTokenString = String(data: appleIDToken, encoding: .utf8) else {
                        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                        return
                      }
                Task {
                    do {
                        _ = try await signInWithAppleUserUseCase.execute(with: .init(IDToken: IDTokenString, rawNonce: nonce, fullName: appleIDCredential.fullName))
                        let showedOnboarding = UserDefaults.standard.bool(forKey: "showedOnboarding")
                        await MainActor.run {
                            if showedOnboarding {
                                navigateToPath = .home
                            } else {
                                navigateToPath = .onboarding
                            }
                        }
                    }
                    catch(let error) {
                        await MainActor.run {
                            switch(error) {
                            case UserRepositoryError.appleSignInFailed:
                                errorMessage = "Try Apple sign in again"
                            default:
                                errorMessage = "Something went wrong, try again."
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    // run entry checks
    func validate() -> Bool {
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
        return true
    }
}
