//
//  CharacterListViewModelTest.swift
//  MovieMvvmDemoAppTests
//
//  Created by Koustav Sen on 29/09/25.
//

import XCTest
import Combine
@testable import MovieMvvmDemoApp

final class CharacterListViewModelTests: XCTestCase {
    var viewModel: CharacterListViewModel!
    var mockService: MockAPIService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockService = MockAPIService()
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        cancellables = nil
        mockService = nil
        super.tearDown()
    }

    func test_fetchQuotesAndCharacters_successfullyFiltersCharactersByMovieId() {
        // Given
        let movie = MovieModel(_id: "5cd95395de30eff6ebccde5d", name: "The Return of the King")
        
        let quote1 = QuoteModel(id: "5cd96e05de30eff6ebcce7e9", dialog: "Deagol!!", movie: "5cd95395de30eff6ebccde5d", character: "5cd99d4bde30eff6ebccfe9e", _id: "5cd96e05de30eff6ebcce7e9")
        let quote2 = QuoteModel(id: "5cd96e05de30eff6ebcce7ed", dialog: "Why?", movie: "5cd95395de30eff6ebccde5d", character: "5cd99d4bde30eff6ebccfca7", _id: "5cd96e05de30eff6ebcce7ed") // different movie
        let quoteList = QuoteListModel(docs: [quote1, quote2])
        mockService.quotesResult = .success(quoteList)
        
        let character1 = CharacterModel(_id: "5cd99d4bde30eff6ebccfe9e", name: "Gollum")
        let character2 = CharacterModel(_id: "5cd99d4bde30eff6ebccfca7", name: "Déagol")
        let characterList = CharacterListModel(docs: [character1, character2])
        mockService.charactersResult = .success(characterList)
        
        let expectation = XCTestExpectation(description: "Characters filtered correctly")

        // When
        viewModel = CharacterListViewModel(movie: movie, apiService: mockService)
        
        viewModel.$characters
            .dropFirst()
            .sink { characters in
                // Then
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters.first?.name, "Gollum")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchQuotes_failure_doesNotFetchCharacters_andShowsError() {
        // Given
        let movie = MovieModel(_id: "5cd95395de30eff6ebccde5d", name: "The Return of the King")
        mockService.quotesResult = .failure(URLError(.badServerResponse))
        
        let expectation = XCTestExpectation(description: "Error handling quote failure")

        // When
        viewModel = CharacterListViewModel(movie: movie, apiService: mockService)

        viewModel.$characters
            .dropFirst()
            .sink { characters in
                // Then
                XCTAssertTrue(characters.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_fetchCharacters_failure_showsError() {
        // Given
        let movie = MovieModel(_id: "5cd95395de30eff6ebccde5d", name: "The Return of the King")
        
        let quote = QuoteModel(id: "5cd96e05de30eff6ebcce7e9", dialog: "Deagol!!", movie: "5cd95395de30eff6ebccde5d", character: "5cd99d4bde30eff6ebccfe9e", _id: "5cd96e05de30eff6ebcce7e9")
        let quoteList = QuoteListModel(docs: [quote])
        mockService.quotesResult = .success(quoteList)

        mockService.charactersResult = .failure(URLError(.badServerResponse))
        
        let expectation = XCTestExpectation(description: "Handles character fetch failure")

        // When
        viewModel = CharacterListViewModel(movie: movie, apiService: mockService)

        viewModel.$characters
            .dropFirst()
            .sink { characters in
                XCTAssertTrue(characters.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1)
    }

    func test_filterQuotesByMovieId_filtersCorrectly() {
        // Given
        let movie = MovieModel(_id: "5cd95395de30eff6ebccde5d", name: "The Return of the King")
        mockService.quotesResult = .success(QuoteListModel(docs: [
            QuoteModel(id: "5cd96e05de30eff6ebcce7e9", dialog: "Deagol!!", movie: "5cd95395de30eff6ebccde5d", character: "5cd99d4bde30eff6ebccfe9e", _id: "5cd96e05de30eff6ebcce7e9"),
            QuoteModel(id: "5cd96e05de30eff6ebcce7ea", dialog: "Deagol!", movie: "5cd95395de30eff6ebccde5d", character: "5cd99d4bde30eff6ebccfe9e", _id: "5cd96e05de30eff6ebcce7ea"),
            QuoteModel(id: "5cd96e05de30eff6ebcce7eb", dialog: "Deagol!", movie: "5cd95395de30eff6ebccde5d", character: "5cd99d4bde30eff6ebccfe9e", _id: "5cd96e05de30eff6ebcce7eb"),
        ]))
        mockService.charactersResult = .success(CharacterListModel(docs: [])) // irrelevant

        let expectation = XCTestExpectation(description: "Quotes are fetched")

        // When
        viewModel = CharacterListViewModel(movie: movie, apiService: mockService)

        viewModel.$quotes
            .dropFirst()
            .sink { quotes in
                let filteredIds = self.viewModel.filterQuotesByMovieId()
                XCTAssertEqual(filteredIds, ["5cd99d4bde30eff6ebccfe9e"])
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
