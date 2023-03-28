import Foundation

enum SharedServices {
    static let cacheService = CacheService()
    static let weatherService = WeatherService(networkService: NetworkService())
}
