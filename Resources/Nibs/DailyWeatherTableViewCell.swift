import UIKit

final class DailyWeatherTableViewCell: UITableViewCell {

    //MARK: Outlets

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconLabel: UIImageView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!

    //MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.font = UIFont(name: "Helvetica", size: 18)
        minTemperatureLabel.font = UIFont(name: "Helvetica", size: 18)
        maxTemperatureLabel.font = UIFont(name: "Helvetica", size: 18)
    }

    //MARK: - Public

    func configure(with weather: DailyWeather) {
        dayLabel.text = DateHelper.getDay(from: weather.date)
        minTemperatureLabel.text = "\(Int(weather.dayDetail.minTemp))°"
        maxTemperatureLabel.text = "\(Int(weather.dayDetail.maxTemp))°"
        iconLabel.loadImage(url: weather.dayDetail.condition.weatherImage)
    }
}
