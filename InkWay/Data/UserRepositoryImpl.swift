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
    private let auth =  Auth.auth()
    private var userId: String? = nil
    
    func getUser(with input: None) async throws -> UserModel {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        do {
            let documentSnapshot = try await db.collection("users").document(userId).getDocument()
            guard let data = documentSnapshot.data() else {
                throw UserRepositoryError.userDataNotFound
            }
            let user = UserModel (
                id: data ["id"] as? String ?? "",
                name: data["name"] as? String ?? "",
                surename: data["surename"] as? String ?? "",
                instagram: data["instagram"] as? String ?? "",
                email: data["email"] as? String ?? "",
                joined: data["joined"] as? TimeInterval ?? 0,
                coord_y: data["coord_y"] as? Float ?? 0,
                coord_x: data["coord_x"] as? Float ?? 0,
                artist: data["artist"] as? Bool ?? false)
            
            return user
        } catch {
            throw UserRepositoryError.failedToFetchCurrentUser(error)
        }
    }
    
    func signIn(with email: String, password: String) async throws -> None {
        do {
            try await auth.signIn(withEmail: email, password: password)
            return None()
        } catch {
            throw UserRepositoryError.loginFailed
        }
    }
    
    func register(with email: String, password: String) async throws -> None {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            let createdUser = UserModel(id: result.user.uid,
                                        name: "",
                                        surename: "",
                                        instagram: "",
                                        email: email,
                                        joined: Date().timeIntervalSince1970,
                                        coord_y: 0,
                                        coord_x: 0,
                                        artist: false)
            try await db.collection("users")
                .document(result.user.uid)
                .setData(createdUser.asDictionary())
            return None()
        } catch(let error) {
            throw UserRepositoryError.registerFailed
        }
    }
}

enum UserRepositoryError: Error {
    case currentUserNotFound
    case userDataNotFound
    case failedToFetchCurrentUser(Error)
    case loginFailed
    case registerFailed
}