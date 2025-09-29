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
}

final class APIService: APIServiceType {
    
    private let baseURL: URL
    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request: APIRequestType {
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
}
