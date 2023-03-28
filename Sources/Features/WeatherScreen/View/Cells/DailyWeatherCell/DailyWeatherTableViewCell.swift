import UIKit

final class DailyWeatherTableViewCell: UITableViewCell {

    // MARK: Outlets

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.font = UIFont(name: "Helvetica", size: 18)
        minTemperatureLabel.font = UIFont(name: "Helvetica", size: 18)
        maxTemperatureLabel.font = UIFont(name: "Helvetica", size: 18)
    }

    // MARK: - Public

    func configure(with weather: DailyWeatherModel) {
        dayLabel.text = DateHelper.getDay(from: weather.day)
        minTemperatureLabel.text = "\(Int(weather.minTemp))°"
        maxTemperatureLabel.text = "\(Int(weather.maxTemp))°"
        iconLabel.loadImage(url: weather.weatherImage)
    }
}
