import UIKit

protocol WeatherViewModelDelegate: AnyObject {
    func updateUI(_ weatherViewModel: WeatherViewModel)
}

final class WeatherViewModel {

    //MARK: - Properties
    
    var currentWeather = CurrentWeatherModel()
    var dailyWeather: [DailyWeather] = []
    var hourlyWeather: [HourlyWeather] = []
    
    weak var delegate: WeatherViewModelDelegate?
    
    let locationService = LocationService()

    //MARK: Public
    
    func dataIsLoaded() {
        locationService.fetchWeatherForCurrentLocation { [weak self] response in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.dailyWeather = response.forecast.daily
                self.currentWeather.city = response.location.city
                self.currentWeather.temperature = response.currentWeather.temperature
                self.currentWeather.summary = response.currentWeather.currentWeatherDescription.summary
                
                if response.forecast.daily.count >= 2 {
                    self.hourlyWeather.append(contentsOf: response.forecast.daily[0].hourly)
                    self.hourlyWeather.append(contentsOf: response.forecast.daily[1].hourly)
                }
                
                self.delegate?.updateUI(self)
            }
        }
    }
}
