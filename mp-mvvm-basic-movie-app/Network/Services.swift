//
//  Services.swift
//  mp-mvvm-basic-movie-app
//
//  Created by Arslan Kaan AYDIN on 17.05.2022.
//

import Alamofire

// MARK : - Protocols
protocol ServiceProtocols {
    func searchMovie(searchMovieName: String, completion: @escaping ([Search]?) -> Void)
    func getMovieDetail(movieImdbId: String, completion: @escaping (DetailResults?) -> Void)
}

final class Services: ServiceProtocols {
    func searchMovie(searchMovieName: String, completion: @escaping ([Search]?) -> Void) {
        AF.request(Constant.NetworkConstant.SearchMovieServiceEndPoint.searchMovie(searchMovieName: searchMovieName)).responseDecodable(of: Result.self) { data in
            guard let data = data.value else {
                completion(nil)
                return
            }
            completion(data.search)
        }
    }
    
    func getMovieDetail(movieImdbId: String, completion: @escaping (DetailResults?) -> Void) {
        AF.request(Constant.NetworkConstant.SearchMovieServiceEndPoint.detailMovie(movieImdbId: movieImdbId)).responseDecodable(of: DetailResults.self) { data in
            guard let data = data.value else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    
}
