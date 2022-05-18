//
//  MovieHomeViewModel.swift
//  mp-mvvm-basic-movie-app
//
//  Created by Arslan Kaan AYDIN on 14.05.2022.
//

import Foundation

protocol MovieHomeProtocol{
    func searchMovie(searchMovieName: String, completion: @escaping ([Search]?) -> Void)
    func getMovieDetail(movieImdbId: String, completion: @escaping (DetailResults?) -> Void)
    var delegate: MovieOutput? { get set }
}


final class MovieHomeViewModel: MovieHomeProtocol {
    var delegate: MovieOutput?
    private var service: ServiceProtocols
    
    init(service: ServiceProtocols) {
        self.service = service
    }
  
}

extension MovieHomeViewModel {
    func searchMovie(searchMovieName: String, completion: @escaping ([Search]?) -> Void) {
        service.searchMovie(searchMovieName: searchMovieName) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    func getMovieDetail(movieImdbId: String, completion: @escaping (DetailResults?) -> Void) {
        service.getMovieDetail(movieImdbId: movieImdbId) { data in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(data)
        }
    }
    
    
}
