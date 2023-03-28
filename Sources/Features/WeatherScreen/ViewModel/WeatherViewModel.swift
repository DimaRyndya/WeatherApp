import UIKit
import CoreLocation
import Network

protocol WeatherViewModelDelegate: AnyObject {
    func updateUI()
    func displayLocationError()
    func displayInternetConnectionError()
}

final class WeatherViewModel: NSObject {
    
    // MARK: - Properties
    
    var currentWeather = CurrentWeatherModel()
    var dailyWeather: [DailyWeatherModel] = []
    var hourlyWeather: [HourlyWeatherModel] = []
    
    weak var delegate: WeatherViewModelDelegate?
    
    private let weatherService: WeatherService
    private let locationManager = CLLocationManager()
    private let cacheService: CacheService
    
    
    // MARK: - Init
    
    init(cacheService: CacheService, weatherService: WeatherService) {
        self.cacheService = cacheService
        self.weatherService = weatherService
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: - Public
    
    func startMonitoring() {
        let monitor = NWPathMonitor()
        
        monitor.start(queue: DispatchQueue.global(qos: .background))
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            
            if path.usesInterfaceType(.wifi) || path.usesInterfaceType(.cellular) {
                if path.status == .satisfied && path.isExpensive == false {
                    self.processLocationState()
                    monitor.cancel()
                }
            } else {
                DispatchQueue.main.async {
                    self.delegate?.displayInternetConnectionError()
                }
            }
        }
    }
    
    func processLocationState() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            delegate?.displayLocationError()
        @unknown default:
            delegate?.displayLocationError()
        }
    }
}

// MARK: - Location Manager Delegate

extension WeatherViewModel: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        processLocationState()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
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
                            maxTemp: $0.dayDetail.maxTemp,
                            weatherImage: $0.dayDetail.condition.weatherImage)
                        }
                        self.currentWeather.city = weather.location.city
                        self.currentWeather.temperature = weather.currentWeather.temperature
                        self.currentWeather.summary = weather.currentWeather.currentWeatherDescription.summary
                        
                        if weather.forecast.daily.count >= 2 {
                            var hourlyWeather: [HourlyWeatherModel] = []
                            
                            hourlyWeather += weather.forecast.daily[0].hourly.map {
                                HourlyWeatherModel(
                                    hour: $0.hour,
                                    temperature: $0.temperature,
                                    image: $0.condition.weatherImage) }
                            hourlyWeather += weather.forecast.daily[1].hourly.map {
                                HourlyWeatherModel(
                                    hour: $0.hour,
                                    temperature: $0.temperature,
                                    image: $0.condition.weatherImage) }
                            
                            if let currentHourIndex = Calendar.current.dateComponents([.day, .hour], from: Date()).hour {
                                
                                hourlyWeather = Array(hourlyWeather[currentHourIndex...currentHourIndex + 23])
                            }
                            
                            self.hourlyWeather = hourlyWeather
                        }
                        
                        self.saveWeather()
                        self.delegate?.updateUI()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func saveWeather() {
        cacheService.save(currentWeather: currentWeather)
        cacheService.save(dailyWeather: dailyWeather)
        cacheService.save(hourlyWeather: hourlyWeather)
    }
    
    func getWeather() {
        currentWeather = cacheService.fetchCurrentWeather()
        dailyWeather = cacheService.fetchDailyWeather()
        hourlyWeather = cacheService.fetchHourlyWeather()
        delegate?.updateUI()
    }
    
    func openSystemSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
