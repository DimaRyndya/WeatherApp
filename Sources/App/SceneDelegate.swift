import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?
    let rootVCBuilder = UIBuilder()
    let sharedService = SharedServices()

    // MARK: - Application lifecycle

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)

        window.rootViewController = rootVCBuilder.buildRootVC(cacheService: sharedService.cacheService)
        self.window = window
        window.makeKeyAndVisible()
    }
}
