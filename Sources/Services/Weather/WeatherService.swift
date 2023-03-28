import UIKit
import CoreLocation

final class WeatherService {
    
    //MARK: - Properties
    
    var currentLocation: CLLocation?
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    //MARK:  - Public
    
    func fetchWeather(completion: @escaping ResponseResult) {
        guard let currentLocation = currentLocation else { return }
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        networkService.requestWeather(latitude: latitude, longitude: longitude, completionHandler: completion)
    }
}
