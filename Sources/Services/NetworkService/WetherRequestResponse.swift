import Foundation

    // MARK: - Weather Request Response

struct WeatherRequestResponse: Decodable {
    let location: UserLocation
    let currentWeather: CurrentWeather
    let forecast: ForecastWeather

    enum CodingKeys: String, CodingKey {
        case location
        case currentWeather = "current"
        case forecast
    }
}

    // MARK: - User Location

struct UserLocation: Decodable {
    let city: String

    enum CodingKeys: String, CodingKey {
        case city = "name"
    }
}

    // MARK: - Current Weather

struct CurrentWeather: Decodable {
    let temperature: Float
    let currentWeatherDescription: CurrentWeatherDescription

    enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case currentWeatherDescription = "condition"
    }
}

    // MARK: - Current Weather Description

struct CurrentWeatherDescription: Decodable {
    let summary: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case summary = "text"
        case image = "icon"
    }
}

    // MARK: - Forecast Weather

struct ForecastWeather: Decodable {
    let daily: [DailyWeather]

    enum CodingKeys: String, CodingKey {
        case daily = "forecastday"
    }
}

    // MARK: - Daily Weather

struct DailyWeather: Decodable {
    let date: String
    let hourly: [HourlyWeather]
    let dayDetail: DayDetails

    enum CodingKeys: String, CodingKey {
        case date
        case dayDetail = "day"
        case hourly = "hour"
    }
}

    // MARK: - Hourly Weather

struct HourlyWeather: Decodable {
    let hour: String
    let temperature: Float
    let condition: HourlyWeatherDescription

    enum CodingKeys: String, CodingKey {
        case hour = "time"
        case temperature = "temp_c"
        case condition
    }
}

    // MARK: - Hourly Weather Description

struct HourlyWeatherDescription: Decodable {
    let weatherImage: String

    enum CodingKeys: String, CodingKey {
        case weatherImage = "icon"
    }
}

    // MARK: - Day Details

struct DayDetails: Decodable {
    let minTemp: Float
    let maxTemp: Float
    let condition: DayConditions

    enum CodingKeys: String, CodingKey {
        case minTemp = "mintemp_c"
        case maxTemp = "maxtemp_c"
        case condition
    }
}

    // MARK: - Day Conditions

struct DayConditions: Decodable {
    let weatherImage: String

    enum CodingKeys: String, CodingKey {
        case weatherImage = "icon"
    }
}
