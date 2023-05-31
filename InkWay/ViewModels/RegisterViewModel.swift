//
//  RegisterViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 22.05.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var surename: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var errorMessage = ""
    
    
    init() {
        // 2do
    }
    
    
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
        }
        print("Register called.")
    }
    
    
    private func insertUserRecord(id: String){
        let createdUser = UserModel(id: id,
                                    name: name,
                                    surename: surename,
                                    instagram: "",
                                    email: email,
                                    joined: Date().timeIntervalSince1970,
                                    role: "user")
        let db = Firestore.firestore()
        db.collection("users")
            .document(id)
            .setData(createdUser.asDictionary())
    }
    
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !surename.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
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
    return true
    }
}
