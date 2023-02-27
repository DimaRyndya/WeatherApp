import UIKit

final class HourlyWeatherTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: - Outlets
    
    @IBOutlet var collectionView: UICollectionView!

    //MARK: Properties
    
    private var hourlyModel: [HourlyWeather] = []

    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let nib = UINib(nibName: "HourlyWeatherCollectionViewCell", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    //MARK:  - CollectionView Data Source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyWeatherCollectionViewCell
        
        cell.configure(with: hourlyModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 100)
    }
    
    func configure(with weather: [HourlyWeather]) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        for arrayHour in weather {
            guard let date = formatter.date(from: arrayHour.hour) else { return }
            let weatherComponents = Calendar.current.dateComponents([.day, .hour], from: date)
            let currentComponents = Calendar.current.dateComponents([.day, .hour], from: Date())
            
            if weatherComponents.hour ?? 0 >= currentComponents.hour ?? 0 || weatherComponents.day != currentComponents.day {
                hourlyModel.append(arrayHour)
            }
        }
        
        collectionView.reloadData()
    }
}
