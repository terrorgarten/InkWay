//
//  UserProfileViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//

import Foundation
//import CoreLocation



// MARK: Handle user profile viewing and change propagation
class UserProfileViewModel: ObservableObject {
    
    @Published var user: UserModel? = nil
    @Published var errorMsg: String? = ""
    @Published var cityName: String = ""
    
    private let fetchCurrentUserUseCase = FetchCurrentUserUseCase(userRepository: UserRepositoryImpl())
    private let logOutUserUseCase       = LogOutCurrentUserUseCase(userRepository: UserRepositoryImpl())
    private let updateUserUseCase       = UpdateUserUseCase(userRepository: UserRepositoryImpl())
    
    init () {
        fetchCurrentUser()
    }
    
    
    
    // logout with Firebase
    func logout() {
        do {
            _ = try logOutUserUseCase.execute(with: None())
        }
        catch(let error) {
            switch error {
            case UserRepositoryError.logOutFailed:
                self.errorMsg = "Could not log you out."
            default:
                self.errorMsg = "Oops! Try again please."
            }
        }
    }
    
    // load user information from the Firestore
    func fetchCurrentUser() {
        Task {
            do {
                self.user = try await fetchCurrentUserUseCase.execute(with: None())
            }
            catch(let error) {
                switch(error) {
                case UserRepositoryError.currentUserNotFound:
                    self.errorMsg = "User was not found."
                case UserRepositoryError.failedToFetchCurrentUser:
                    self.errorMsg = "Check your connection"
                case UserRepositoryError.userDataNotFound:
                    self.errorMsg = "Your data were not found."
                default:
                    self.errorMsg = "Please try again later."
                }
            }
        }
    }
    
    
//    // change user status to artist
//    func updateUserAsArtist(_ editedArtistUser: UserModel) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        let db = Firestore.firestore()
//        let userRef = db.collection("users").document(userId)
//
//        userRef.updateData([
//            "artist": editedArtistUser.artist,
//            "coord_y": editedArtistUser.coord_y,
//            "coord_x": editedArtistUser.coord_x,
//        ]) { error in
//            if let error = error {
//                self.errorMsg = "Failed to update user: \(error.localizedDescription)"
//            }
//        }
//        fetchCurrentUser()
//    }
//
//
//    // update user information
//    func updateUser(_ editedUser: UserModel) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            return
//        }
//
//        let db = Firestore.firestore()
//        let userRef = db.collection("users").document(userId)
//
//        userRef.updateData([
//            "name": editedUser.name,
//            "surename": editedUser.surename,
//            "instagram": editedUser.instagram
//        ]) { error in
//            if let error = error {
//                self.errorMsg = "Failed to update user: \(error.localizedDescription)"
//            }
//        }
//        //reload
//        fetchCurrentUser()
//    }
//
//
//    // get city from x y coords
//    private func reverseGeocode(location: CLLocationCoordinate2D) {
//        let geocoder = CLGeocoder()
//        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
//
//        geocoder.reverseGeocodeLocation(clLocation) { [weak self] placemarks, error in
//            guard error == nil, let placemark = placemarks?.first else {
//                self?.cityName = ""
//                return
//            }
//
//            DispatchQueue.main.async {
//                self?.cityName = placemark.locality ?? ""
//            }
//        }
//    }
    
}
