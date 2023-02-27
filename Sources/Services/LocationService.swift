import UIKit
import CoreLocation


final class LocationService: NSObject {

    //MARK: - Properties

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let networkService = NetworkService()

    //MARK:  - Public

    func configureLocation() {

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func fetchWeatherForCurrentLocation(completion: @escaping ResponseResult) {
        guard let currentLocation = currentLocation else { return }

        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude

        networkService.requestWeatherForLocation(with: latitude, and: longitude, completionHandler: completion)
    }
}

    //MARK: - Location Manager Delegate

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
        }
    }
}
