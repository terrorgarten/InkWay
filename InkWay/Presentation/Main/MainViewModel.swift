//
//  MainViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Combine


// main viewmodel, handles the app routing and contect switching
// based on the currentUserArtistStatus
class MainViewModel: ObservableObject {
    
    @Published var currentUserId: String = ""
    @Published var currentUserArtistStatus: Bool = false
    
    private var handler: AuthStateDidChangeListenerHandle?
    public var signedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    private var cancellables = Set<AnyCancellable>()
    public var userProfileViewModel = UserProfileViewModel()
    
    
    init() {
        userProfileViewModel.objectWillChange
            .sink { [weak self] _ in
                self?.fetchCurrentUser()
            }
            .store(in: &cancellables)

        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
        fetchCurrentUser()
    }
    
    
    
    
    // loads current user artist status
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
                self.currentUserArtistStatus = data["artist"] as? Bool ?? false
            }
        }
    }
    
}
