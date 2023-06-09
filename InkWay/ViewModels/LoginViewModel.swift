//
//  File.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation
import FirebaseAuth

// MARK: Login handler
class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    
    // logint user with firebase
    func login() {
        guard validate() else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            // check for sign-in success or failure
            if let error = error {
                // handle sign-in failure
                self.errorMessage = "Invalid credentials."
                print("Sign-in failed with error: \(error.localizedDescription)")
            } else {
                print("Sign-in successful")
            }
        }
        print("Login passed")
    }
    
    
    // run entry checks
    func validate() -> Bool {
        errorMessage = ""
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
