//
//  NetworkConstant.swift
//  mp-mvvm-basic-movie-app
//
//  Created by Arslan Kaan AYDIN on 17.05.2022.
//

import Foundation

extension Constant {
    class NetworkConstant{
        enum SearchMovieServiceEndPoint: String {
            case BASE_URL = "http://www.omdbapi.com"
            case API_KEY = "apikey=4b0018ac"
            
            static func searchMovie(searchMovieName: String) -> String {
                "\(BASE_URL.rawValue)?s=\(searchMovieName)&\(API_KEY.rawValue)"
            }
            
            static func detailMovie(movieImdbId: String) -> String {
                "\(BASE_URL.rawValue)?i=\(movieImdbId)&\(API_KEY.rawValue)"
            }
        }
    }
}
