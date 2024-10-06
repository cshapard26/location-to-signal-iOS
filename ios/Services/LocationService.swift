import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()

    func requestLocation(completion: @escaping (Double, Double, String) -> Void) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // Simulating signal strength retrieval
        let signalStrength = "Good"
        if let location = locationManager.location {
            completion(location.coordinate.latitude, location.coordinate.longitude, signalStrength)
        }
    }
}
