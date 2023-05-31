//
//  LocationViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 29.05.2023.
//

import Foundation
import CoreLocation


// MARK: Inspired by https://www.youtube.com/watch?v=poSmKJ_spts
class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    
    static let shared = LocationManager()
    
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    func requestLocation() {
        // only access when in use
        print("Loc request fired")
        print(manager.requestWhenInUseAuthorization())
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("CLA STATUS:")
        print(status)
        switch status {
            
        case .notDetermined:
            print("DEBUG: not determined")
        case .restricted:
            print("DEBUG: restricted")
        case .denied:
            print("DEBUG: denied")
            dump(self.manager)
        case .authorizedAlways:
            print("DEBUG: always")
        case .authorizedWhenInUse:
            print("DEBUG: when in use")
        @unknown default:
            print("DEBUG: default")
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            print("Failed guard location manager")
            return
        }
        // update publish var
        print("userLocation fired:")
        self.userLocation = location
        print(self.userLocation!)
    }
}
    
