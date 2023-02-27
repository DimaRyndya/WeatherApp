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
    }

    //MARK: - Public

    func configure(with weather: DailyWeather) {

        dayLabel.text = getDayFromDate(weather.date)
        dayLabel.font = UIFont(name: "Helvetica", size: 18)

        minTemperatureLabel.text = "\(Int(weather.dayDetail.minTemp))°"
        minTemperatureLabel.font = UIFont(name: "Helvetica", size: 18)
        
        maxTemperatureLabel.text = "\(Int(weather.dayDetail.maxTemp))°"
        maxTemperatureLabel.font = UIFont(name: "Helvetica", size: 18)

        iconLabel.loadImage(url: weather.dayDetail.condition.weatherImage)
    }

    //MARK: - Helper Methods

    private func getDayFromDate(_ stringDate: String) -> String {

        let formatter = DateFormatter()
        let now = Date()

        formatter.dateFormat = "yyyy-MM-dd"

        guard let date = formatter.date(from: stringDate) else { return "" }

        if Calendar.current.isDate(date, equalTo: now, toGranularity: .day) {
            return "Today"
        }

        formatter.dateFormat = "EEEE"

        return formatter.string(from: date)
    }
}
