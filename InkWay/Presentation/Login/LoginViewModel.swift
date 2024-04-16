//
//  File.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation

// MARK: Login handler
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String? = nil
    @Published var navigateToPath: Destination? = nil
    
    private let signInUserUseCase = SignInUserUseCase(userRepository: UserRepositoryImpl())
    
    // logint user with firebase
    func login() {
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
