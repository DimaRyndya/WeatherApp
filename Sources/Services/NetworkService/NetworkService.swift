import Foundation
import CoreLocation

enum NetworkFailure: Error {
    case decodeError
}

typealias ResponseResult = (Result<WeatherRequestResponse, NetworkFailure>) -> Void

final class NetworkService {

    // MARK: - Request params

    private let baseURL = "http://api.weatherapi.com/v1"
    private let requestURL = "/forecast.json"
    private let apiKey = "b590599a9cde440d930193106232202"

    // MARK:  - Public

    func requestWeather(
        latitude: CLLocationDegrees,
        longitude: CLLocationDegrees,
        completionHandler: @escaping ResponseResult) {

        let baseParams = [
            "key": apiKey,
            "q": "\(latitude),\(longitude)",
            "days": "10"
        ]

        guard var urlComponents = URLComponents(string: baseURL + requestURL) else { return }

        urlComponents.setQueryItems(with: baseParams)

        guard let contentsURL = urlComponents.url else { return }

        var request = URLRequest(url: contentsURL)

        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, _ in
            if let data = data, let response = response as? HTTPURLResponse {
                print(response.statusCode)

                do {
                    let decoder = JSONDecoder()
                    let reuslt = try decoder.decode(WeatherRequestResponse.self, from: data)
                    completionHandler(.success(reuslt))
                } catch {
                    completionHandler(.failure(NetworkFailure.decodeError))
                }

                return
            }
        }
        .resume()
    }
}
