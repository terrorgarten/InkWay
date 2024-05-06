//
//  UserProfileViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import CoreLocation

let us  =  UserModel (
    id: "1",
    name: "Name",
    surename: "Surname",
    instagram: "ig",
    email: "",
    joined: 0,
    coord_y:  0,
    coord_x:  0,
    artist:  true)

let us2  =  UserModel (
    id: "2",
    name: "Name",
    surename: "Surname",
    instagram: "ig",
    email: "",
    joined: 0,
    coord_y:  0,
    coord_x:  0,
    artist:  true)

let us3  =  UserModel (
    id: "3",
    name: "Name",
    surename: "Surname",
    instagram: "ig",
    email: "",
    joined: 0,
    coord_y:  0,
    coord_x:  0,
    artist:  true)

let us4  =  UserModel (
    id: "4",
    name: "Name",
    surename: "Surname",
    instagram: "ig",
    email: "",
    joined: 0,
    coord_y:  0,
    coord_x:  0,
    artist:  true)


// MARK: Handle user profile viewing and change propagation
class UserProfileViewModel: ObservableObject {
    
    @Published var user: UserModel? = nil
    @Published var errorMsg: String? = ""
    @Published var cityName: String = ""
    @Published var likedPosts: [PostModel] = posts1
    @Published var follwoedArtits: [UserModel] = [us2,us3,us4,us]
    @Published var followingArtists: [UserModel] = [us,us2,us3,us4]
    
    init () {
        fetchCurrentUser()
    }
    
    
    
    // logout with Firebase
    func logout() {
        print("logout pressed")
        
        do {
            try Auth.auth().signOut()
        } catch {
            errorMsg = "Could not sign you out. Please check the internet connection."
            print(IWError.LogoutError)
        }
    }
    
    
    // load user information from the Firestore
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
                    coord_y: data["coord_y"] as? Float ?? 0,
                    coord_x: data["coord_x"] as? Float ?? 0,
                    artist: data["artist"] as? Bool ?? false)
                guard let user = self.user else {
                    return
                }
                self.reverseGeocode(location: CLLocationCoordinate2D(latitude: CLLocationDegrees(user.coord_y), longitude: CLLocationDegrees(user.coord_x)))
            }
        }
    }
    
    
    // change user status to artist
    func updateUserAsArtist(_ editedArtistUser: UserModel) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.updateData([
            "artist": editedArtistUser.artist,
            "coord_y": editedArtistUser.coord_y,
            "coord_x": editedArtistUser.coord_x,
        ]) { error in
            if let error = error {
                self.errorMsg = "Failed to update user: \(error.localizedDescription)"
            }
        }
        fetchCurrentUser()
    }
    
    
    // update user information
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
        //reload
        fetchCurrentUser()
    }
    
    
    // get city from x y coords
    private func reverseGeocode(location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { [weak self] placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                self?.cityName = ""
                return
            }
            
            DispatchQueue.main.async {
                self?.cityName = placemark.locality ?? ""
            }
        }
    }
    
}
