//
//  FindArtistsViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 30.05.2023.
//

import Foundation
import CoreLocationUI
import CoreLocation
import MapKit
import Combine
import FirebaseFirestore
import FirebaseAuth

// MARK: Artist discovery manager
class FindArtistsViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var coordinates: CLLocationCoordinate2D? = nil
    @Published var cityName: String = ""
    @Published var artists: [UserModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    let locationManager = CLLocationManager()
    var userId: String = ""
    
    // override locationManager
    override init() {
        super.init()
        locationManager.delegate = self
        self.createCanecellables()
        guard (Auth.auth().currentUser?.uid) != nil else {
            return
        }
        self.userId = Auth.auth().currentUser?.uid ?? ""
    }
    
    // create subs
    private func createCanecellables() {
        $coordinates
            .sink { [weak self] newLocation in
                guard let purifiedLocation = newLocation else {
                    return
                }
                self?.reverseGeocode(location: purifiedLocation)
            }
            .store(in: &cancellables)
        $coordinates
            .sink { [weak self] _ in
                self?.fetchUsers()
            }
            .store(in: &cancellables)
    }
    
    // request location only once when we actually need it.
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    // on update, load coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }
        
        DispatchQueue.main.async {
            self.coordinates = latestLocation.coordinate
        }
    }
    
    // on fail just print error for now
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // decode x y coords to city name
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
    
    // load user objects. Should use cursors or something to not load all at once
    func fetchUsers() {
        guard let purifiedCoords = self.coordinates else {
            return
        }
        let x = Float(purifiedCoords.longitude)
        let y = Float(purifiedCoords.latitude)
    
        let db = Firestore.firestore()
        db.collection("users")
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching users: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                var users = documents.compactMap { queryDocumentSnapshot -> UserModel? in
                    return try? queryDocumentSnapshot.data(as: UserModel.self)
                }
                
                // filter out current user
                users.removeAll { $0.id == self?.userId }
                // filter out any non artist users left
                users.removeAll { $0.artist == false}
                //sort up by dist
                users.sort { user1, user2 in
                    let distance1 = self?.calculateDistance((x, y), user1)
                    let distance2 = self?.calculateDistance((x, y), user2)
                    
                    return distance1 ?? 0 < distance2 ?? 0
                }
                self?.artists = users
            }
    }

    // calculates the distance between two locations
    func calculateDistance(_ coordinates1: (x: Float, y: Float), _ coordinates2: UserModel) -> Float {
        let deltaX = coordinates1.x - coordinates2.coord_x
        let deltaY = coordinates1.y - coordinates2.coord_y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }
    
}
