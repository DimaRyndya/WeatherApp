import UIKit

final class WeatherHeaderView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var summaryLabel: UILabel!

    // MARK: - Properties

    static let nibName = "WeatherHeaderView"

    // MARK: - Public
    
    func configure(with weather: CurrentWeatherModel) {
        cityLabel.text = weather.city
        temperatureLabel.text = "\(Int(weather.temperature))"
        summaryLabel.text = weather.summary
    }
}


