import Foundation

// TODO: Rewrite to enum with static lets

final class SharedServices {
    let cacheService = CacheService()
    let weatherService = WeatherService(networkService: NetworkService())
}
