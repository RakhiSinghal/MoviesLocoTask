//
//  Modal.swift
//  MoviesLoco
//
//  Created by Rakhi Singhal on 28/09/24.
//

import Foundation
struct Movie: Decodable {
    let title: String
    let poster: String
    let year: String
    let imdbID: String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case poster = "Poster"
        case year = "Year"
        case imdbID = "imdbID"
    }
}
struct MovieSearchResponse: Decodable {
    let search: [Movie]
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
struct MovieDetails: Decodable {
    let title: String
    let released: String
    let director: String
    let plot: String
    let poster: String
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case released = "Released"
        case director = "Director"
        case plot = "Plot"
        case poster = "Poster"
    }
}
