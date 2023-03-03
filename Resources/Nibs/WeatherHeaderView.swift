import UIKit

final class WeatherHeaderView: UIView {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    func configure(with weather: CurrentWeatherModel) {
        cityLabel.text = weather.city
        temperatureLabel.text = "\(Int(weather.temperature))"
        summaryLabel.text = weather.summary
    }
}


