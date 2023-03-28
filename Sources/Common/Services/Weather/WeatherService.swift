import UIKit
import CoreLocation

final class WeatherService {

    //MARK: - Properties

    var currentLocation: CLLocation?
    let networkService = NetworkService()

    //MARK:  - Public

    func fetchWeather(completion: @escaping ResponseResult) {
        guard let currentLocation = currentLocation else { return }

        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        networkService.requestWeather(latitude: latitude, longitude: longitude, completionHandler: completion)
    }
}
