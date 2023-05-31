//
//  MainViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation
import FirebaseAuth

class MainViewModel: ObservableObject {
    
    @Published var currentUserId: String = ""
    @Published var currentUserRole: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    public var signedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    init() {
        // whenever user signs, published var gets set.
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // ensure main thread usage
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
}
