import UIKit

final class UIBuilder {

    func buildRootVC(cacheService: CacheService) -> WeatherTableViewController {
        let weatherTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! WeatherTableViewController
        let weatherViewModel = WeatherViewModel(cacheService: cacheService)

        weatherViewModel.delegate = weatherTableVC
        weatherTableVC.viewModel = weatherViewModel
        
        return weatherTableVC
    }
}
