import UIKit
import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
    func updateUI()
}

final class WeatherViewModel: NSObject {

    // MARK: - Properties
    
    var currentWeather = CurrentWeatherModel()
    var dailyWeather: [DailyWeather] = []
    var hourlyWeather: [HourlyWeather] = []
    
    weak var delegate: WeatherViewModelDelegate?
    
    let weatherService = WeatherService()
    let locationManager = CLLocationManager()

    // MARK: Public

    func configureLocation() {

        // Handle if location is not confirmed

        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
}

//MARK: - Location Manager Delegate

extension WeatherViewModel: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, weatherService.currentLocation == nil {
            weatherService.currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            weatherService.fetchWeather { [weak self] response in
                guard let self else { return }

                switch response {
                case .success(let weather):
                    DispatchQueue.main.async {
                        self.dailyWeather = weather.forecast.daily
                        self.currentWeather.city = weather.location.city
                        self.currentWeather.temperature = weather.currentWeather.temperature
                        self.currentWeather.summary = weather.currentWeather.currentWeatherDescription.summary

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
        }
    }
}
