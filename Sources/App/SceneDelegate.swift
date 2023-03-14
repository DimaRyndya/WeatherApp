import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let cacheService = CacheService()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let weatherTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! WeatherTableViewController

        let weatherViewModel = WeatherViewModel(cacheService: cacheService)
        weatherTableVC.viewModel = weatherViewModel


        window.rootViewController = weatherTableVC
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        cacheService.saveContext()
    }

}

