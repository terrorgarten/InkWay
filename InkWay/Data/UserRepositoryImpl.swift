//
//  UserRepositoryImpl.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// TODO - just example
class UserRepositoryImpl: UserRepository {
    
    private let db = Firestore.firestore()
    
    func getUser(with input: None) async throws -> UserModel {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        do {
            let documentSnapshot = try await db.collection("users").document(userId).getDocument()
            guard let data = documentSnapshot.data() else {
                throw UserRepositoryError.userDataNotFound
            }
            
            throw UserRepositoryError.userDataNotFound
                
        } catch {
            throw UserRepositoryError.failedToFetchCurrentUser(error)
        }
    }
}

enum UserRepositoryError: Error {
    case currentUserNotFound
    case userDataNotFound
    case failedToFetchCurrentUser(Error)
}
