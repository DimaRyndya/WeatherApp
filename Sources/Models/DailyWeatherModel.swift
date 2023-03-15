import Foundation

class DailyWeatherModel {
    let day: String
    let minTemp: Float
    let maxTemp: Float
    var weatherImage: String


    init(day: String, minTemp: Float, maxTemp: Float, weatherImage: String = "") {
        self.day = day
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.weatherImage = weatherImage
    }

    convenience init(persistedDailyWeather: PersistedDailyWeather) {
        self.init(day: persistedDailyWeather.day, minTemp: persistedDailyWeather.minTemp, maxTemp: persistedDailyWeather.maxTemp)
    }
}
