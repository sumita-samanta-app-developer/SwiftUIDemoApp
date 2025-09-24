//
//  MovieService.swift
//  MovieMvvmDemoApp
//
//  Created by Koustav Sen on 25/09/25.
//

import Foundation

struct MovieRequest: APIRequestType {
    typealias Response = MovieListModel
    
    var path: String { return "/movie" }
}
