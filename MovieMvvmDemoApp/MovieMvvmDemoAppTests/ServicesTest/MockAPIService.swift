//
//  MockAPIService.swift
//  MovieMvvmDemoAppTests
//
//  Created by Koustav Sen on 29/09/25.
//

import XCTest
import Foundation
import Combine
@testable import MovieMvvmDemoApp

final class MockAPIService: APIServiceType {
    var movieResult: Result<MovieListModel, APIServiceError>!
    var quotesResult: Result<QuoteListModel, Error>!
    var charactersResult: Result<CharacterListModel, Error>!
    
    func response<Request>(from request: Request) -> AnyPublisher<Request.Response, APIServiceError> where Request : APIRequestType {
        if let result = movieResult as? Result<Request.Response, APIServiceError> {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: .responseError).eraseToAnyPublisher()
        }
    }

    // Dummy stubs
    func fetchQuotes() -> AnyPublisher<QuoteListModel, Error> {
        return quotesResult.publisher.eraseToAnyPublisher()
    }
    
    func fetchCharacters() -> AnyPublisher<CharacterListModel, Error> {
        return charactersResult.publisher.eraseToAnyPublisher()
    }
}
