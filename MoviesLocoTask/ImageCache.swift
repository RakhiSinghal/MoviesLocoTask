//
//  ImageCache.swift
//  MoviesLoco
//
//  Created by Rakhi Singhal on 28/09/24.
//

import Foundation
import UIKit
class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
extension UIImageView {
    func loadImage(from urlString: String) {
        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageCache.shared.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
        }.resume()
    }
}

