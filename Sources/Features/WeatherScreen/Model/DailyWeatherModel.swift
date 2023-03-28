import Foundation

final class DailyWeatherModel {

    // MARK: - Properties

    static var counter = 0

    var id: Int
    let day: String
    let minTemp: Float
    let maxTemp: Float
    var weatherImage: String

    // MARK: - Init

    init(day: String, minTemp: Float, maxTemp: Float, weatherImage: String) {
        DailyWeatherModel.counter += 1
        self.id = DailyWeatherModel.counter
        self.day = day
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.weatherImage = weatherImage
    }

    convenience init(persistedDailyWeather: PersistedDailyWeather) {
        self.init(
            day: persistedDailyWeather.day,
            minTemp: persistedDailyWeather.minTemp,
            maxTemp: persistedDailyWeather.maxTemp,
            weatherImage: "")
    }
}
