//
//  MovieModel.swift
//  mp-mvvm-basic-movie-app
//
//  Created by Arslan Kaan AYDIN on 17.05.2022.
//

import Foundation

// MARK: - Result
struct Result: Codable {
    let search: [Search]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case poster = "Poster"
    }
}


