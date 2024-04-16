//
//  RegisterViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: Handle registration
class RegisterViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var errorMessage: String? = nil
    @Published var isTermsAccepted: Bool = false
    @Published var navigateToPath: Destination? = nil
    
    // use firebase to register a new user
    func register() {
        guard validate() else {
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid else {
                self!.errorMessage = error?.localizedDescription ?? ""
                return
            }
            self?.insertUserRecord(id: userId)
            if UserDefaults.standard.bool(forKey: "createTattooerProfile") {
                self?.navigateToPath = .createTattooerProfile
            } else {
                if UserDefaults.standard.bool(forKey: "showedOnboarding") {
                    self?.navigateToPath = .home
                } else {
                    self?.navigateToPath = .onboarding
                }
            }
        }
    }
    
    
    // handle user saving to document
    private func insertUserRecord(id: String){
        let createdUser = UserModel(id: id,
                                    name: "",
                                    surename: "",
                                    instagram: "",
                                    email: email,
                                    joined: Date().timeIntervalSince1970,
                                    coord_y: 0,
                                    coord_x: 0,
                                    artist: false)
        
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(createdUser.asDictionary())
    }
    
    
    // validate registration data
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
