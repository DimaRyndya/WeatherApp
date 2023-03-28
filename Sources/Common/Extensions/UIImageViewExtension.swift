import UIKit

extension UIImageView {
    
    func loadImage(url: String) {
        guard let imageURL = URL(string: "https:" + url) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }
    }
}
