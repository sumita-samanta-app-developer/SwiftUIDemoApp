//
//  MovieService.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation

struct MovieRequest: APIRequestType {
    typealias Response = MovieListModel
    
    var url: URL { return URL(string: "\(AppConstants.BASEURL)\(APIEndpoint.movies)")! }
}
