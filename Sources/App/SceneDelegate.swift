import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    private let uiBuilder = UIBuilder()
    private let sharedService = SharedServices()
    
    // MARK: - Application lifecycle
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = uiBuilder.buildRootVC(cacheService: sharedService.cacheService, weatherService: sharedService.weatherService)
        self.window = window
        window.makeKeyAndVisible()
    }
}
