import UIKit

final class HourlyWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Outlets
    
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: Properties
    
    private var hourlyModel: [HourlyWeatherModel] = []

    static let nibName = "HourlyWeatherTableViewCell"
    static let identifier = "HourlyWeatherCell"

    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: HourlyWeatherCollectionViewCell.nibName, bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: HourlyWeatherCollectionViewCell.nibName)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    // MARK:  - CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        
        cell.configure(with: hourlyModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
    
    func configure(with weather: [HourlyWeatherModel]) {
        self.hourlyModel = weather
        
        collectionView.reloadData()
    }
}
