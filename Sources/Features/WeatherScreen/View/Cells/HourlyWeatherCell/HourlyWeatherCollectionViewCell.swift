import UIKit

final class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Outlets
    
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var imageLabel: UIImageView!
    @IBOutlet private weak var temperatureLabel: UILabel!

    // MARK: - Properties

    static let nibName = "HourlyWeatherCollectionViewCell"
    static let identifier = "HourlyCollectionViewCell"
    
    // MARK: - Public
    
    func configure(with weather: HourlyWeatherModel) {
        hourLabel.text = DateHelper.getTime(from: weather.hour)
        imageLabel.contentMode = .scaleAspectFit
        imageLabel.loadImage(url: weather.image)
        temperatureLabel.text = "\(Int(weather.temperature))°"
    }
}
