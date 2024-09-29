//
//  DetailViewController.swift
//  MoviesLoco
//
//  Created by Rakhi Singhal on 28/09/24.
//
import Foundation
import UIKit
class DetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    var movieID: String?
    var movies: MovieDetails?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButton()
        self.navigationItem.title = "Movie Details"
        NetworkManager.shared.fetchMovieDetails(movieID: movieID!) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                print("abcx \(movieDetails)")
                DispatchQueue.main.async {
                    self?.updateUI(details: movieDetails)
                }
            case .failure(let error):
                print("Error fetching movie details: \(error)")
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
    }
    func updateUI(details: MovieDetails) {
        titleLabel.text =  details.title
        releaseDateLabel.text = "Release Date: \(details.released)"
        directorLabel.text = "Director: \(details.director)"
        plotLabel.text = details.plot
        posterImageView.loadImage(from: details.poster)
    }
    private func setupCustomBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.title = ""
        navigationItem.leftBarButtonItem = backButton
    }
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}


