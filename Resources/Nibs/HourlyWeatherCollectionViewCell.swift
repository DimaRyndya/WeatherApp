import UIKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    
    @IBOutlet var hourLabel: UILabel!
    @IBOutlet var imageLabel: UIImageView!
    @IBOutlet var temperatureLabel: UILabel!

    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Public
    
    func configure(with weather: HourlyWeather) {
        
        hourLabel.text = getTimeFromDate(weather.hour)
        imageLabel.contentMode = .scaleAspectFit
        imageLabel.loadImage(url: weather.condition.weatherImage)
        temperatureLabel.text = "\(Int(weather.temperature))°"
    }

    //MARK: Helper Methods
    
    private func getTimeFromDate(_ stringDate: String) -> String {
        
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        guard let date = formatter.date(from: stringDate) else { return "" }
        
        if Calendar.current.isDate(date, equalTo: Date(), toGranularity: .hour) {
            return "Now"
        }
        
        formatter.dateFormat = "HH"
        
        return formatter.string(from: date)
    }
}
