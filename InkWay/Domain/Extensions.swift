//
//  Extensions.swift
//  InkWay
//
//  Created by terrorgarten on 23.05.2023.
//
import CoreLocation
import Foundation

// Prepares JSON for db operations
extension Encodable {
    
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            return json ?? [:]
        } catch {
            return [:]
        }
    }
    
}


// converts time interval to human readable form
extension TimeInterval {
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: self))
    }
    
}


// assigns the location to our user from CLLocationCoordinate2D
// only changes the type of CLLocationDegree, which is a Float typecast
extension ArtistModel {
    mutating func saveCLLocation(location: CLLocationCoordinate2D) {
        self.coord_y = Float(location.latitude)
        self.coord_x = Float(location.longitude)
    }
    
    func isValidCoordinates() -> Bool {
        
        let validLatitudeRange = -90.0...90.0
        let validLongitudeRange = -180.0...180.0
        
        let isValidLatitude = validLatitudeRange.contains(CLLocationDegrees(self.coord_y))
        let isValidLongitude = validLongitudeRange.contains(CLLocationDegrees(self.coord_x))
        
        return isValidLatitude && isValidLongitude
    }
    
    func getCityNameFromLocation() -> String {
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.coord_y), longitude: CLLocationDegrees(self.coord_x))
        if location.isValidCoordinates() {
            return location.reverseGeocode()
        } else {
            return "Uknown city"
        }
    }
}


// for decoding coords into city names - BROKEN THREAD SYNC?
extension CLLocationCoordinate2D {
    public func reverseGeocode() -> String {
        
        var cityName: String = "City not found"
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            guard error == nil, let placemark = placemarks?.first else {
                print("ext guard fail")
                cityName = "City not found"
                return
            }
            
            DispatchQueue.main.async {
                cityName = placemark.locality ?? "City not found"
                print("ext city name in async: \(cityName)")
            }
        }
        print("ext retting")
        return cityName
    }
    
    
    // validate location2D
    func isValidCoordinates() -> Bool {
        let validLatitudeRange = -90.0...90.0
        let validLongitudeRange = -180.0...180.0
        
        let isValidLatitude = validLatitudeRange.contains(self.latitude)
        let isValidLongitude = validLongitudeRange.contains(self.longitude)
        
        return isValidLatitude && isValidLongitude
    }
    
}
