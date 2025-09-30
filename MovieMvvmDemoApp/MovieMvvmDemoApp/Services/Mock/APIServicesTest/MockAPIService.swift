//
//  MockAPIService.swift
//  MovieMvvmDemoAppTests
//
//  Created by Sumita Samanta on 29/09/25.
//

import XCTest
import Foundation
import Combine
@testable import MovieMvvmDemoApp

final class MockAPIService: APIServiceType {
    var movieResult: Result<MovieListModel, APIServiceError>!
    var quotesResult: Result<QuoteListModel, APIServiceError>!
    var charactersResult: Result<CharacterListModel, APIServiceError>!
    
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request : APIRequestType {
        if let result = movieResult as? Result<Request.Response, APIServiceError> {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: .responseError).eraseToAnyPublisher()
        }
    }
    
    public func getMockMovieList() async throws -> MovieListModel? {
        return try MockService().decodableObject(forResource: "MockMovieListModel", type: MovieListModel.self)
    }
    
    public func getMockQuoteList() async throws -> QuoteListModel? {
        return try MockService().decodableObject(forResource: "MockQuoteListModel", type: QuoteListModel.self)
    }
    
    public func getMockCharacterListList() async throws -> CharacterListModel? {
        return try MockService().decodableObject(forResource: "MockCharacterListModel", type: CharacterListModel.self)
    }
}
