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

    // MARK: - Public
    
    func configure(with weather: HourlyWeatherModel) {
        hourLabel.text = DateHelper.getTime(from: weather.hour)
        imageLabel.contentMode = .scaleAspectFit
        imageLabel.loadImage(url: weather.image)
        temperatureLabel.text = "\(Int(weather.temperature))°"
    }
}
