import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Properties
    
    var window: UIWindow?
    private let uiBuilder = UIBuilder()
    
    // MARK: - Application lifecycle
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = uiBuilder.buildRootVC(cacheService: SharedServices.cacheService, weatherService: SharedServices.weatherService)
        self.window = window
        window.makeKeyAndVisible()
    }
}
