//
//  UserRepositoryImpl.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import GoogleSignIn

class UserRepositoryImpl: UserRepository {
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()

    // Fetches the current user's profile from Firestore
    func getUser() async throws -> UserModel {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        let documentSnapshot = try await db.collection("users").document(userId).getDocument()
        guard let data = documentSnapshot.data() else {
            throw UserRepositoryError.userDataNotFound
        }
        return UserModel(from: data)
    }
    
    // Signs in using email and password
    func signIn(with email: String, password: String) async throws -> None {
        do {
            try await auth.signIn(withEmail: email, password: password)
        } catch {
            throw UserRepositoryError.loginFailed
        }
        return None()
    }
    
    // Registers user with email and password
    func register(with email: String, password: String) async throws -> None {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            try await createUserProfile(id: result.user.uid, email: email)
        } catch {
            throw UserRepositoryError.registerFailed
        }
        return None()
    }
    
    // Handles Apple sign in and user profile creation
    func signInWithApple(with IDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> (Bool, UserModel?) {
        do {
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: IDToken, rawNonce: rawNonce)
            let result = try await auth.signIn(with: credential)
            let userExists = try await userExists(userId: result.user.uid)
            
            
            if !userExists {
                return (true, nil)

            } else {
                let name = fullName?.givenName ?? ""
                let surname = fullName?.familyName ?? ""
                let username = fullName?.givenName ?? "Secret user"
                
                let userModel = UserModel(
                                id: result.user.uid,
                                username: username,
                                name: name,
                                surename: surname,
                                instagram: "",
                                email: "",
                                joined: Date().timeIntervalSince1970,
                                likedDesigns: [],
                                artist: false
                            )
                return (false, userModel)
            }
            
            if result.additionalUserInfo?.isNewUser == true {
                
            }
        } catch {
            throw UserRepositoryError.appleSignInFailed
        }
    }
    
    func signUpWithApple(with IDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> UserModel {
        do {
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: IDToken, rawNonce: rawNonce)
            let result = try await auth.signIn(with: credential)
            let userExists = try await userExists(userId: result.user.uid)
            let isNewOAuthUser = result.additionalUserInfo?.isNewUser
            
            if isNewOAuthUser == true && !userExists {
                let userId = result.user.uid
                let email = result.user.email ?? ""
                let name = fullName?.givenName ?? ""
                let surename = fullName?.familyName ?? ""
                let username = result.user.displayName ?? ""
                
                let newUserModel = UserModel(id: userId,
                                             username: username,
                                             name: name,
                                             surename: surename,
                                             instagram: "",
                                             email: email,
                                             joined: Date().timeIntervalSince1970,
                                             likedDesigns: [],
                                             artist: false)
                return newUserModel
            }
            
        } catch {
            throw UserRepositoryError.appleSignUpFailed
        }
    }
    
    
    
    func signUpWithGoogle(with IDTokenString: String, accessTokenString: String) async throws -> UserModel {
        do {
            let credential = GoogleAuthProvider.credential(withIDToken: IDTokenString, accessToken: accessTokenString)
            let authResult = try await auth.signIn(with: credential)
            let alreadyExists = try await userExists(userId: authResult.user.uid)
            let isNewOAuthUser = authResult.additionalUserInfo?.isNewUser
            
            if isNewOAuthUser == true && !alreadyExists {
                let userId = authResult.user.uid
                let email = authResult.user.email ?? ""
                let username = authResult.user.displayName ?? ""
                let name = authResult.additionalUserInfo?.profile?["given_name"] as? String ?? ""
                let surname = authResult.additionalUserInfo?.profile?["family_name"] as? String ?? ""

                let newUserModel = UserModel(
                                id: userId,
                                username: username,
                                name: name,
                                surename: surname,
                                instagram: "",
                                email: email,
                                joined: Date().timeIntervalSince1970,
                                likedDesigns: [],
                                artist: false
                            )
                return newUserModel
                
            } else {
                throw UserRepositoryError.userAlreadyExists
            }
        } catch {
            throw UserRepositoryError.googleSignUpFailed
        }
    }
    
    // Function for logging in with google
    func signInWithGoogle(with IDTokenString: String, accessTokenString: String) async throws -> (Bool, UserModel?) {
        do {
            let credential = GoogleAuthProvider.credential(withIDToken: IDTokenString, accessToken: accessTokenString)
            let authResult = try await auth.signIn(with: credential)

            // Login successful, we have such user
            if try await userExists(userId: String(authResult.user.uid)) {
                return (true, nil)
            
            // We dont have such user in our DB, lets get the user details and create it.
            } else {
                let userId = authResult.user.uid
                let email = authResult.user.email ?? ""
                let username = authResult.user.email ?? "Secret user"
                let name = authResult.additionalUserInfo?.profile?["given_name"] as? String ?? ""
                let surname = authResult.additionalUserInfo?.profile?["family_name"] as? String ?? ""

                let userModel = UserModel(
                                id: userId,
                                username: username,
                                name: name,
                                surename: surname,
                                instagram: "",
                                email: email,
                                joined: Date().timeIntervalSince1970,
                                likedDesigns: [],
                                artist: false
                            )
                return (false, userModel)
            }
        } catch {
            throw UserRepositoryError.googleSignInFailed
        }
    }

    // Logs out the current user
    func logOut() throws -> None {
        try auth.signOut()
        return None()
    }

    private func userExists(userId: String) async throws -> Bool {
        let document = db.collection("users").document(userId)
        let snapshot = try await document.getDocument()
        return snapshot.exists
    }
    
    // Helper function to create a user profile in Firestore
    private func createUserProfile(userModel: UserModel) async throws -> None {
        try await db.collection("users").document(userModel.id).setData(userModel.asDictionary())
        return None()
    }

    // Simplified method for creating user profiles without full UserModel
    private func createUserProfile(id: String, email: String, name: String = "", surname: String = "") async throws {
        let newUser = UserModel(id: id, username: email, name: name, surename: surname, instagram: "", email: email, joined: Date().timeIntervalSince1970, likedDesigns: [], artist: false)
        try await db.collection("users").document(id).setData(newUser.asDictionary())
    }
}

enum UserRepositoryError: Error {
    case currentUserNotFound
    case userDataNotFound
    case failedToFetchCurrentUser(Error)
    case loginFailed
    case registerFailed
    case appleSignInFailed
    case googleSignInFailed
    case logOutFailed
    case userAlreadyExists
    case googleSignUpFailed
    case userDoesNotExist
    case appleSignUpFailed
}
