import UIKit

final class UIBuilder {
    
    func buildRootVC(cacheService: CacheService, weatherService: WeatherService) -> WeatherTableViewController {
        let weatherTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? WeatherTableViewController ?? WeatherTableViewController()
        let weatherViewModel = WeatherViewModel(cacheService: cacheService, weatherService: weatherService)
        
        weatherViewModel.delegate = weatherTableVC
        weatherTableVC.viewModel = weatherViewModel
        
        return weatherTableVC
    }
}
