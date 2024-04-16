//
//  RegisterViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation

// MARK: Handle registration
class RegisterViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var errorMessage: String? = nil
    @Published var isTermsAccepted: Bool = false
    @Published var navigateToPath: Destination? = nil
    
    private let registerNewUserUseCase = RegisterNewUserUseCase(userRepository: UserRepositoryImpl())
    
    func register() {
        guard validate() else {
            return
        }
        Task {
            do {
                _ = try await registerNewUserUseCase.execute(with: .init(email: email, password: password))
                if UserDefaults.standard.bool(forKey: "createTattooerProfile") {
                    await MainActor.run {
                        navigateToPath = .createTattooerProfile
                    }
                } else {
                    if UserDefaults.standard.bool(forKey: "showedOnboarding") {
                        await MainActor.run {
                            navigateToPath = .home
                        }
                    } else {
                        await MainActor.run {
                            navigateToPath = .onboarding
                        }
                    }
                }
            }
            catch(let error) {
                await MainActor.run {
                    switch(error) {
                    case UserRepositoryError.registerFailed:
                        errorMessage = "Registration failed."
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
