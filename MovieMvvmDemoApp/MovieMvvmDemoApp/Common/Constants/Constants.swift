//
//  Constants.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 29/09/25.
//

enum APIEndpoint {
    case movies
    case quote
    case character

    var path: String {
        switch self {
            case .movies: return "movie"
            case .quote: return "quote"
            case .character: return "character"
        }
    }
}
struct AppConstants {
    static let BASEURL = "https://e21a086a-4f08-425a-b99c-a9bbe7539a40.mock.pstmn.io/v2/"
}
