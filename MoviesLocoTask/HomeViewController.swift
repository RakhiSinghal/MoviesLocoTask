//
//  HomeViewController.swift
//  MoviesLoco
//
//  Created by Rakhi Singhal on 28/09/24.
//

import Foundation
import UIKit
class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    var movies = [Movie]()
    var currentPage = 1
    var searchQuery = ""
    
    var totalPages = 5
    var isLoading = false
    @IBOutlet weak var txtSearch: UISearchBar!
    @IBOutlet weak var movieCollection: UICollectionView!
    override func viewDidLoad() {
        print("home")
        super.viewDidLoad()
        movieCollection.delegate = self
        movieCollection.dataSource = self
        txtSearch.delegate = self
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let totalSpacing: CGFloat = 20
        let availableWidth = view.frame.width - totalSpacing
        let itemWidth = (availableWidth / 2) - (totalSpacing)
        layout.itemSize = CGSize(width: itemWidth, height: 300)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        movieCollection.collectionViewLayout = layout
        movieCollection.backgroundColor = .white
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchQuery = query
        movies.removeAll()
        currentPage = 1
        fetchMovies()
        searchBar.resignFirstResponder()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        movies.removeAll()
        movieCollection.reloadData()
    }
    func fetchMovies() {
        isLoading = true
        NetworkManager.shared.fetchMovies(searchQuery: searchQuery, page: currentPage) { result in
            switch result {
            case .success(let newMovies):
                self.movies.append(contentsOf: newMovies)
                DispatchQueue.main.async {
                    self.setupCollectionView()
                    self.movieCollection.reloadData()
                    self.isLoading = false
                }
            case .failure(let error):
                print(error)
                self.isLoading = false
            }
        }
    }
    // MARK: - Pagination: Detect when user scrolls to the bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height && !isLoading {
            currentPage += 1
            if currentPage <= totalPages {
                fetchMovies()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.configure(with: movies[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.movieID = movie.imdbID
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
