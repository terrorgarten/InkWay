//
//  UserProfileViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class UserProfileViewModel: ObservableObject {
    
    @Published var user: UserModel? = nil
    @Published var errorMsg: String? = ""

    
    
    init () {
        fetchCurrentUser()
    }
    
    func logout() {
        print("logout pressed")
        
        do {
            try Auth.auth().signOut()
        } catch {
            errorMsg = "Could not sign you out. Please check the internet connection."
            print(IWError.LogoutError)
        }
    }
    
    func fetchCurrentUser() {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self.user = UserModel (
                    id: data ["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    surename: data["surename"] as? String ?? "",
                    instagram: data["instagram"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0,
                    role: "user")
            }
        }
    }
    

    
    func updateUser(_ editedUser: UserModel) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.updateData([
            "name": editedUser.name,
            "surename": editedUser.surename,
            "instagram": editedUser.instagram
        ]) { error in
            if let error = error {
                self.errorMsg = "Failed to update user: \(error.localizedDescription)"
            }
        }
        fetchCurrentUser()
    }
}
