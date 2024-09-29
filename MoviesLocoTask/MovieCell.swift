//
//  MovieCell.swift
//  MoviesLoco
//
//  Created by Rakhi Singhal on 29/09/24.
//

import Foundation
import UIKit

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        if let posterURL = URL(string: movie.poster) {
            loadImage(from: posterURL)
        }
    }
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Failed to load image: \(error)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}
