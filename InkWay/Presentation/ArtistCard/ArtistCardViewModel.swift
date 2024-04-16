//
//  ArtistCardViewModel.swift
//  InkWay
//
//  Created by terrorgarten on 31.05.2023.
//

import CoreLocation
import FirebaseFirestore
import FirebaseStorage
import UIKit



// MARK: handles generating data for the discovery cards
class ArtistCardViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var cityName: String = ""
    @Published var distance: Int? = nil
    
    let artist: UserModel
    let findArtistsViewModel: FindArtistsViewModel
    
    
    init(artist: UserModel, findArtistsViewModel: FindArtistsViewModel) {
        self.findArtistsViewModel = findArtistsViewModel
        self.artist = artist
        reverseGeocode()
    }
    
    
    
    // decode x and y coords and publishes them via cityName
    private func reverseGeocode() {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: CLLocationDegrees(artist.coord_y), longitude: CLLocationDegrees(artist.coord_x))
        
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
    
    
    // load the first image from the database of the artist and expose via image
    public func getArtistImage() {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        _ = storage.reference().child("designs")
        db.collection("designs").whereField("userId", isEqualTo: artist.id).getDocuments { [weak self] querySnapshot, error in
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No image document found for artist \(self?.artist.id ?? "")")
                return
            }
            
            guard let design = documents.first?.data() else {
                print("Failed to retrieve design data")
                return
            }
            
            guard let designURLString = design["designURL"] as? String, let designURL = URL(string: designURLString) else {
                print("Invalid design URL")
                return
            }
            // using url sesh to get our data from server
            URLSession.shared.dataTask(with: designURL) { [weak self] data, _, error in
                if let error = error {
                    print("Error downloading image: \(error.localizedDescription)")
                    return
                }
                
                guard let imageData = data else {
                    print("Error retrieving image data")
                    return
                }
                
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }.resume()
        }
    }
    
    
    // loads the distance published var in rounded kilometres
    public func setDistance(){
        
        let sourceCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(artist.coord_y), longitude: CLLocationDegrees(artist.coord_x))

        guard let destinationCoordinate = findArtistsViewModel.coordinates else {
            return
        }
        
        // just convert and calculate
        let sourceLocation = CLLocation(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
        let destinationLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        let distanceInMeters = sourceLocation.distance(from: destinationLocation)
        let distanceInKm = distanceInMeters / 1000
        self.distance = Int(distanceInKm)
    }
    
}
