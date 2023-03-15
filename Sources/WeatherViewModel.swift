import UIKit
import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
    func updateUI()
}

final class WeatherViewModel: NSObject {

    // MARK: - Properties
    
    var currentWeather = CurrentWeatherModel()
    var dailyWeather: [DailyWeatherModel] = []
    var hourlyWeather: [HourlyWeather] = []
    
    weak var delegate: WeatherViewModelDelegate?
    
    let weatherService = WeatherService()
    let locationManager = CLLocationManager()
    let cacheService: CacheService

    init(cacheService: CacheService) {
        self.cacheService = cacheService
    }

    // MARK: Public

    func configureLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

// MARK: - Location Manager Delegate

extension WeatherViewModel: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            configureLocation()
        case .notDetermined:
            break
        case .restricted, .denied:
            displayLocationError()
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, weatherService.currentLocation == nil {
            weatherService.currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            weatherService.fetchWeather { [weak self] response in
                guard let self else { return }

                switch response {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self.dailyWeather = weather.forecast.daily.map { DailyWeatherModel(
                            day: $0.date,
                            minTemp: $0.dayDetail.minTemp,
                            maxTemp: $0.dayDetail.maxTemp)
                        }
                        self.currentWeather.city = weather.location.city
                        self.currentWeather.temperature = weather.currentWeather.temperature
                        self.currentWeather.summary = weather.currentWeather.currentWeatherDescription.summary
                        self.cacheService.save(currentWeather: self.currentWeather)
                        self.cacheService.save(dailyWeather: self.dailyWeather)

                        if weather.forecast.daily.count >= 2 {
                            var hourlyWeather: [HourlyWeather] = []
                            hourlyWeather.append(contentsOf: weather.forecast.daily[0].hourly)
                            hourlyWeather.append(contentsOf: weather.forecast.daily[1].hourly)

                            if let currentHourIndex = Calendar.current.dateComponents([.day, .hour], from: Date()).hour {

                                hourlyWeather = Array(hourlyWeather[currentHourIndex...currentHourIndex + 23])
                            }

                            self.hourlyWeather = hourlyWeather
                        }
                        
                        self.delegate?.updateUI()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            if let current = cacheService.fetchCurrentWeather(), let daily = cacheService.fetchDailyWeather() {
                currentWeather = current
                dailyWeather = daily
                delegate?.updateUI()
            }
        }
    }

    // MARK: - Helper methods

    private func displayLocationError() {
        let alert = UIAlertController(title: "Location Serviced Disabled",
                                      message: "Please enable your location to present current weather",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(settingsAction)

        if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundInactive }) as? UIWindowScene {
            let currentWindow = windowScene.windows.first { $0.isKeyWindow }
            currentWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
}
