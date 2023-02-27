import Foundation

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

struct UserLocation: Decodable {
    let city: String

    enum CodingKeys: String, CodingKey {
        case city = "name"
    }
}

struct CurrentWeather: Decodable {
    let temperature: Float
    let currentWeatherDescription: CurrentWeatherDescription

    enum CodingKeys: String, CodingKey {
        case temperature = "temp_c"
        case currentWeatherDescription = "condition"
    }
}

struct CurrentWeatherDescription: Decodable {
    let summary: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case summary = "text"
        case image = "icon"
    }
}

struct ForecastWeather: Decodable {
    let daily: [DailyWeather]

    enum CodingKeys: String, CodingKey {
        case daily = "forecastday"
    }
}

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

struct HourlyWeatherDescription: Decodable {
    let weatherImage: String

    enum CodingKeys: String, CodingKey {
        case weatherImage = "icon"
    }
}

struct DayDetails: Decodable {
    let minTemp: Float
    let maxTemp: Float
    let condition: DayConditiions

    enum CodingKeys: String, CodingKey {
        case minTemp = "mintemp_c"
        case maxTemp = "maxtemp_c"
        case condition
    }
}

struct DayConditiions: Decodable {
    let weatherImage: String

    enum CodingKeys: String, CodingKey {
        case weatherImage = "icon"
    }
}
