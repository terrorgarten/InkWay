//
//  LocationTestViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 30.05.2023.
//

import Foundation
import CoreLocationUI
import CoreLocation
import MapKit
import Combine

class LocationTestViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var coordinates: CLLocationCoordinate2D? = nil
    @Published var cityName: String = ""
    
    private var cancellable: AnyCancellable?
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        
        cancellable = $coordinates
                    .sink { [weak self] newLocation in
                        print("geocoding!")
                        guard let purifiedLocation = newLocation else {
                            print("sink guard caught nil")
                            return
                        }
                        self?.reverseGeocode(location: purifiedLocation)
                    }
    }
    
    func requestAllowOnceLocationPermission() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            print("guard error")
            return
        }
        
        DispatchQueue.main.async {
            self.coordinates = latestLocation.coordinate
        }
    }
    
    // MARK: Handle locationmanager delegate errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    
    
    // MARK: Convert location to city
    private func reverseGeocode(location: CLLocationCoordinate2D) {
        print("geocoding in..")
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

