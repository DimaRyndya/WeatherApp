import Foundation

final class HourlyWeatherModel {

    // MARK: - Properties

    static var counter = 0

    let id: Int
    let hour: String
    let temperature: Float
    let image: String

    // MARK: - Init

    init(hour: String, temperature: Float, image: String) {
        HourlyWeatherModel.counter += 1
        self.id = HourlyWeatherModel.counter
        self.hour = hour
        self.temperature = temperature
        self.image = image
    }

    convenience init(persistedHourlyWeather: PersistedHourlyWeather) {
        self.init(
            hour: persistedHourlyWeather.hour,
            temperature: persistedHourlyWeather.temperature,
            image: "")
    }
}
