//
//  UserRepositoryImpl.swift
//  InkWay
//
//  Created by Oliver Bajus on 10.03.2024.
//

import Foundation
import CryptoKit
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import CoreLocation


// TODO - just example
class UserRepositoryImpl: UserRepository {
    
    private let db = Firestore.firestore()
    private let auth =  Auth.auth()
    private let storage = Storage.storage()
    
    // Fetches the current user's profile from Firestore
    func getUser(with input: None) async throws -> UserModel {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        let documentSnapshot = try await db.collection("users").document(userId).getDocument()
        guard let data = documentSnapshot.data() else {
            throw UserRepositoryError.userDataNotFound
        }
        return UserModel(from: data)
    }
    
    func fetchUserWithId(with id: String) async throws -> UserModel {
        let documentSnapshot = try await db.collection("users").document(id).getDocument()
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
    func register(with email: String, password: String) async throws -> String {
        let result: AuthDataResult
        do {
            result = try await auth.createUser(withEmail: email, password: password)
        } catch {
            print("Error: \(error)")
            throw UserRepositoryError.registerFailed
        }
        // Return new user id as string
        return result.user.uid
    }
    
    
    // Logs out the current user
    func signOut(with input: None) throws -> None {
        try auth.signOut()
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
                
                // Create user model from the data
                let userModel = UserModel(
                    id: result.user.uid,
                    name: name,
                    surename: surname,
                    instagram: "",
                    email: result.user.email ?? "",
                    joined: Date().timeIntervalSince1970
                )
                
                return (false, userModel)
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
                
                return UserModel(
                    id: userId,
                    name: name,
                    surename: surename,
                    instagram: "",
                    email: email,
                    joined: Date().timeIntervalSince1970
                )
            } else {
                throw UserRepositoryError.userAlreadyExists
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
                let name = authResult.additionalUserInfo?.profile?["given_name"] as? String ?? ""
                let surname = authResult.additionalUserInfo?.profile?["family_name"] as? String ?? ""

                let newUserModel = UserModel(
                                id: userId,
                                name: name,
                                surename: surname,
                                instagram: "",
                                email: email,
                                joined: Date().timeIntervalSince1970
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
                let name = authResult.additionalUserInfo?.profile?["given_name"] as? String ?? ""
                let surname = authResult.additionalUserInfo?.profile?["family_name"] as? String ?? ""

                 let userModel = UserModel(
                    id: userId,
                    name: name,
                    surename: surname,
                    instagram: "",
                    email: email,
                    joined: Date().timeIntervalSince1970,
                    artist: false,
                    bio: "",
                    coord_y: 0.0,
                    coord_x: 0.0, 
                    likedDesigns: [],
                    likedDesignsCount: 0,
                    followedArtists: [],
                    followedArtistsCount: 0,
                    followers: [],
                    followersCount: 0,
                    profilePictureURL: URL(string: "https://static.vecteezy.com/system/resources/previews/020/911/740/non_2x/user-profile-icon-profile-avatar-user-icon-male-icon-face-icon-profile-icon-free-png.png")!
                )
                return (false, userModel)
            }
        } catch {
            throw UserRepositoryError.googleSignInFailed
        }
    }

    // MARK: Design likes
    func addUserLikedDesign(with designId: String) async throws -> None {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }

        let userDoc = db.collection("users").document(userId)
        
        // Make the logic of db handling without transaction
        do {
            let userSnapshot = try await userDoc.getDocument()
            var likedDesigns = userSnapshot.data()?["likedDesigns"] as? [String] ?? []
            
            // Add design only if user has not liked it before
            if likedDesigns.contains(designId) {
                return None()
            } else {
                likedDesigns.append(designId)
            }
            
            
            try await userDoc.updateData([
                "likedDesigns": likedDesigns,
                "likedDesignsCount": FieldValue.increment(Int64(1))
            ])
        } catch {
            throw UserRepositoryError.failedToAddLikedDesign
        }
        
        return None()
    }
    
    func removeUserLikedDesign(with designId: String) async throws -> None {
        // remove from user liked - removed from likedDesigns lists and decrement likedDesignsCount
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        // Get user document
        let userDoc = db.collection("users").document(userId)
        do {
            try await _ = db.runTransaction { (transaction, errorPointer) -> Any? in
                let snapshot: DocumentSnapshot
                do {
                    snapshot = try transaction.getDocument(userDoc)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    return nil
                }
                
                guard var likedDesigns = snapshot.data()?["likedDesigns"] as? [String] else {
                    errorPointer?.pointee = NSError(domain: "UserRepositoryError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found"])
                    return nil
                }
                
                // Check if the designId is actually in the liked list
                if let index = likedDesigns.firstIndex(of: designId) {
                    likedDesigns.remove(at: index)
                    transaction.updateData(["likedDesigns": likedDesigns], forDocument: userDoc)
                    // Decrement likedDesignsCount
                    let likedDesignsCount = snapshot.data()?["likedDesignsCount"] as? Int ?? 0
                    transaction.updateData(["likedDesignsCount": likedDesignsCount - 1], forDocument: userDoc)
                }
                
                return None()
            }
        } catch {
            throw UserRepositoryError.failedToFetchCurrentUser(error)
        }
        return None()
    }
    
    func getAllUserLikedDesigns() async throws -> [DesignModel] {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let snapshot = try await userDoc.getDocument()
        guard let likedDesigns = snapshot.data()?["likedDesigns"] as? [String] else {
            throw UserRepositoryError.userLikedDesignsNotFound
        }
        
        var designs: [DesignModel] = []
        for designId in likedDesigns {
            let designDoc = db.collection("designs").document(designId)
            let designSnapshot = try await designDoc.getDocument()
            guard let design = DesignModel(document: designSnapshot) else {
                throw UserRepositoryError.designNotFound
            }
            designs.append(design)
        }
        
        return designs
    }
    
    func getLikedDesignsCount() async throws -> Int {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let snapshot = try await userDoc.getDocument()
        return snapshot.data()?["likedDesignsCount"] as? Int ?? 0
    }

    private func userExists(userId: String) async throws -> Bool {
        let document = db.collection("users").document(userId)
        let snapshot = try await document.getDocument()
        return snapshot.exists
    }

    // Simplified method for creating user profiles without full UserModel
    private func createUserProfile(id: String, email: String, name: String = "", surname: String = "") async throws {
        let newUser = UserModel(
            id: id,
            name: name,
            surename: surname,
            instagram: "",
            email: email,
            joined: Date().timeIntervalSince1970)
        try await db.collection("users").document(id).setData(newUser.asDictionary())
    }
    
    func createUserProfile(with user: UserModel) async throws -> None {
        try await db.collection("users").document(user.id).setData(user.asDictionary())
        return None()
    }
    
    func updateUserProfile(with userModel: UserModel) async throws -> None {
        if userModel.name.isEmpty {
            throw UserRepositoryError.invalidUserData
        }
        try await db.collection("users").document(userModel.id).updateData(userModel.asDictionary())
        return None()
    }
    
    // MARK: Profile picture management
    func uploadProfilePicture(image: UIImage) async throws -> URL {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        // Convert UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw UserRepositoryError.imageConversionFailed
        }
        
        let storageRef = storage.reference().child("profile_pictures/\(userId).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await storageRef.downloadURL()
            // Update user document with the new profile picture URL
            try await db.collection("users").document(userId).updateData(["profilePictureURL": downloadURL.absoluteString])
            return downloadURL
        } catch {
            throw UserRepositoryError.uploadFailed(error)
        }
    }
    
    func removeProfilePicture() async throws -> None {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let storageRef = storage.reference().child("profile_pictures/\(userId).jpg")
        
        do {
            try await storageRef.delete()
            // Set default profile picture URL
            try await db.collection("users").document(userId).updateData(["profilePictureURL": UserModel.defaultImageURL])
        } catch {
            throw UserRepositoryError.deleteFailed(error)
        }
        return None()
    }
    
    
    // MARK: - Social functions
    func getAllFollowedArtists() async throws -> [UserModel] {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let snapshot = try await userDoc.getDocument()
        guard let followedArtists = snapshot.data()?["followedArtists"] as? [String] else {
            throw UserRepositoryError.userDataNotFound
        }
        
        var artistsList: [UserModel] = []
        for artistId in followedArtists {
            let artistDoc = db.collection("users").document(artistId)
            let artistSnapshot = try await artistDoc.getDocument()
            guard let artist = UserModel(document: artistSnapshot) else {
                throw UserRepositoryError.artistNotFound
            }
            
            artistsList.append(artist)
        }
        
        return artistsList
    }
    
    func getFollowedArtistCount() async throws -> Int {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let snapshot = try await userDoc.getDocument()
        guard let followedArtists = snapshot.data()?["followedArtists"] as? [String] else {
            throw UserRepositoryError.userDataNotFound
        }
        
        return followedArtists.count
    }
    
    func getAllFollowers() async throws -> [UserModel] {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let snapshot = try await userDoc.getDocument()
        guard let followers = snapshot.data()?["followers"] as? [String] else {
            throw UserRepositoryError.userDataNotFound
        }
        
        var followersList: [UserModel] = []
        for followerId in followers {
            let followerDoc = db.collection("users").document(followerId)
            let followerSnapshot = try await followerDoc.getDocument()
            guard let follower = UserModel(document: followerSnapshot) else {
                throw UserRepositoryError.userDataNotFound
            }
            followersList.append(follower)
        }
        
        return followersList
    }
    
    // Calculates in meters
    func getDistanceToUser(with user: UserModel) async throws -> Double {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = Firestore.firestore().collection("users").document(userId)
        let snapshot = try await userDoc.getDocument()
        
        guard let x_coord = snapshot.data()?["x_coord"] as? Double,
              let y_coord = snapshot.data()?["y_coord"] as? Double else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userCoordinates = CLLocation(latitude: CLLocationDegrees(x_coord), longitude: CLLocationDegrees(y_coord))
        let otherUserCoordinates = CLLocation(latitude: CLLocationDegrees(user.coord_x), longitude: CLLocationDegrees(user.coord_y))
        
        // Calculate the distance in meters between the two locations
        return userCoordinates.distance(from: otherUserCoordinates)
    }
    
    func getFollowerCount() async throws -> Int {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let snapshot = try await userDoc.getDocument()
        return snapshot.data()?["followersCount"] as? Int ?? 0
    }
    
    func followArtist(with artistId: String) async throws -> None {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let artistDoc = db.collection("users").document(artistId)
        
        let userSnapshot = try await userDoc.getDocument()
        let artistSnapshot = try await artistDoc.getDocument()
        
        guard var user = UserModel(document: userSnapshot) else {
            throw UserRepositoryError.userDataNotFound
        }
        guard var artist = UserModel(document: artistSnapshot) else {
            throw UserRepositoryError.userDataNotFound
        }
        
        if user.followedArtists.contains(artistId) {
            throw UserRepositoryError.userAlreadyLikedDesign
        }
        
        user.followedArtists.append(artistId)
        user.followedArtistsCount += 1
        artist.followers.append(userId)
        artist.followersCount += 1
        
        try await db.collection("users").document(userId).updateData(["followedArtists": user.followedArtists])
        try await db.collection("users").document(userId).updateData(["followedArtistsCount": user.followedArtistsCount])
        try await db.collection("users").document(artistId).updateData(["followers": artist.followers])
        try await db.collection("users").document(artistId).updateData(["followersCount": artist.followersCount])
        
        return None()
    }
    
    func unfollowArtist(with artistId: String) async throws -> None {
        guard let userId = auth.currentUser?.uid else {
            throw UserRepositoryError.currentUserNotFound
        }
        
        let userDoc = db.collection("users").document(userId)
        let artistDoc = db.collection("users").document(artistId)
        
        let userSnapshot = try await userDoc.getDocument()
        let artistSnapshot = try await artistDoc.getDocument()
        
        guard var user = UserModel(document: userSnapshot) else {
            throw UserRepositoryError.userDataNotFound
        }
        guard var artist = UserModel(document: artistSnapshot) else {
            throw UserRepositoryError.userDataNotFound
        }
        
        if !user.followedArtists.contains(artistId) {
            throw UserRepositoryError.userAlreadyLikedDesign
        }
        
        user.followedArtists.removeAll(where: { $0 == artistId })
        user.followedArtistsCount -= 1
        artist.followers.removeAll(where: { $0 == userId })
        artist.followersCount -= 1
        
        try await db.collection("users").document(userId).updateData(["followedArtists": user.followedArtists])
        try await db.collection("users").document(userId).updateData(["followedArtistsCount": user.followedArtistsCount])
        try await db.collection("users").document(artistId).updateData(["followers": artist.followers])
        try await db.collection("users").document(artistId).updateData(["followersCount": artist.followersCount])
        
        return None()
    }
}

enum UserRepositoryError: Error {
    case currentUserNotFound
    case imageConversionFailed
    case uploadFailed(Error)
    case deleteFailed(Error)
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
    case addingLikedDesignFailed
    case invalidUserData
    case userLikedDesignsNotFound
    case designNotFound
    case userAlreadyLikedDesign
    case failedToAddLikedDesign
    case artistNotFound
}

extension UserModel {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else {
            return nil
        }
        self.init(from: data)
    }
}

extension DesignModel {
    init?(document: DocumentSnapshot) {
        guard let data = document.data() else {
            return nil
        }
        self.init(from: data)
    }
}
