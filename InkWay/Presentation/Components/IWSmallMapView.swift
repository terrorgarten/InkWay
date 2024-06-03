import SwiftUI
import MapKit
import CoreLocation

struct IWMapView: View {
    @State private var region: MKCoordinateRegion
    @State private var showSheet: Bool = false
    
    var location: CLLocationCoordinate2D
    let label: String
    
    init(latitude: Float, longitude: Float, label: String) {

        
        
        self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        if !self.location.isValidCoordinates() {
            self.location = CLLocationCoordinate2D(latitude: CLLocationDegrees(37.77), longitude: CLLocationDegrees(-122.26))
        }
        
        self.label = label
        _region = State(initialValue: MKCoordinateRegion(
            center: location,
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        ))
    }
    
    var body: some View {
        VStack {
            IWMapPreview(region: $region, location: location, label: label)
                .onTapGesture {
                    showSheet = true
                }
                .sheet(isPresented: $showSheet) {
                    NavigationView {
                        IWFullScreenMapView(region: $region, location: location, label: label)
                            .navigationBarItems(trailing: Button("Dismiss") {
                                showSheet = false
                            })
                    }
                }
        }
    }
}

struct IWMapView_Previews: PreviewProvider {
    static var previews: some View {
        IWMapView(latitude: 37.7749, longitude: -122.4194, label: "John tattoo")
    }
}

struct IWMapPreview: View {
    @Binding var region: MKCoordinateRegion
    var location: CLLocationCoordinate2D
    var label: String
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: .none, annotationItems: [IdentifiableLocation(coordinate: location, label: label)]) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    Text(location.label)
                        .font(.caption)
                        .padding(10)
                        .background(Color.accentColor.opacity(0.8))
                        .cornerRadius(10)
                    
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.accentColor)
                        .font(.title)
                }
            }
        }
        .frame(height: 200)
    }
}

struct IdentifiableLocation: Identifiable {
    var id = UUID()
    var coordinate: CLLocationCoordinate2D
    var label: String
}

struct IWFullScreenMapView: View {
    @Binding var region: MKCoordinateRegion
    var location: CLLocationCoordinate2D
    var label: String
    
    var body: some View {
        Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, userTrackingMode: .none, annotationItems: [IdentifiableLocation(coordinate: location, label: label)]) { location in
            MapAnnotation(coordinate: location.coordinate) {
                VStack {
                    Text(location.label)
                        .font(.caption)
                        .padding(5)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .font(.title)
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct IWFullScreenMapView_Previews: PreviewProvider {
    static var previews: some View {
        IWFullScreenMapView(region: .constant(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            latitudinalMeters: 2000,
            longitudinalMeters: 2000
        )), location: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), label: "San Francisco")
    }
}
