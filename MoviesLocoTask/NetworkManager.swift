//
//  NetworkManager.swift
//  MoviesLoco
//
//  Created by Rakhi Singhal on 28/09/24.
//
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://www.omdbapi.com/"
    private let apiKey = "a93a97ea"
    private init() {}

    private func performRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedObject))
                }
            } catch {
                completion(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
    
    // Method to fetch movies (search with pagination)
    func fetchMovies(searchQuery: String, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)?apikey=\(apiKey)&s=\(searchQuery)&page=\(page)"
        performRequest(urlString: urlString) { (result: Result<MovieSearchResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.search))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // Method to fetch movie details
    func fetchMovieDetails(movieID: String, completion: @escaping (Result<MovieDetails, Error>) -> Void) {
        let urlString = "\(baseURL)?apikey=\(apiKey)&i=\(movieID)"
        performRequest(urlString: urlString, completion: completion)
    }
}

// Custom error types for better error handling
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
}
