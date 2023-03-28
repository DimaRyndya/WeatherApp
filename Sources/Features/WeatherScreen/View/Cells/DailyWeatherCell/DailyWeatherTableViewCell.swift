import UIKit

final class DailyWeatherTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var iconLabel: UIImageView!
    @IBOutlet private weak var minTemperatureLabel: UILabel!
    @IBOutlet private weak var maxTemperatureLabel: UILabel!
    
    // MARK: - Public
    
    func configure(with weather: DailyWeatherModel) {
        dayLabel.text = DateHelper.getDay(from: weather.day)
        minTemperatureLabel.text = "\(Int(weather.minTemp))°"
        maxTemperatureLabel.text = "\(Int(weather.maxTemp))°"
        iconLabel.loadImage(url: weather.weatherImage)
    }
}
