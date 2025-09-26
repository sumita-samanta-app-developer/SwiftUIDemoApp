//
//  APIService.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import Combine

protocol APIRequestType {
    associatedtype Response: Decodable
    
    var path: String { get }
}

protocol APIServiceType {
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType
    
//    func fetchMovies() -> AnyPublisher<MovieListModel, Error>
}

final class APIService: APIServiceType {
    
    private let baseURL: URL
    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
    
//        let pathURL = URL(string: request.path, relativeTo: baseURL)!
//        
//        var urlComponents = URLComponents(url: pathURL, resolvingAgainstBaseURL: true)!
//        //urlComponents.queryItems = request.queryItems
//        var request = URLRequest(url: urlComponents.url!)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decorder = JSONDecoder()
        decorder.keyDecodingStrategy = .convertFromSnakeCase
        return URLSession.shared.dataTaskPublisher(for: baseURL)
            .map { data, urlResponse in data }
            .mapError { _ in APIServiceError.responseError }
            .decode(type: Request.Response.self, decoder: decorder)
            .mapError(APIServiceError.parseError)
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
//    func fetchMovies() -> AnyPublisher<MovieListModel, Error> {
//        guard let url = URL(string: "https://e21a086a-4f08-425a-b99c-a9bbe7539a40.mock.pstmn.io/v2/movie") else {
//            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
//        }
//
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: MovieListModel.self, decoder: JSONDecoder())
//            .eraseToAnyPublisher()
//    }
}
