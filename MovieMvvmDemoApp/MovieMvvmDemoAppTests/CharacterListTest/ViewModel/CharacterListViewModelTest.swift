//
//  CharacterListViewModelTest.swift
//  MovieMvvmDemoAppTests
//
//  Created by Sumita Samanta on 29/09/25.
//

import XCTest
import Combine
@testable import MovieMvvmDemoApp

final class CharacterListViewModelTests: XCTestCase {
    
    var viewModel: CharacterListViewModel!
    var mockAPIService: MockAPIService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockAPIService = nil
        cancellables = nil
        super.tearDown()
    }

    func makeMovieModel() async throws -> MovieModel {
        let movieListModel = try await mockAPIService.getMockMovieList()
        let movie: MovieModel = (movieListModel?.docs.first)!
        return movie
    }
    
    func testFetchQuotesAndCharacters_Success() async throws {
        let expectation = self.expectation(description: "Quotes and characters loaded")

        // Setup mock data
//        let quoteListModel = try await mockAPIService.getMockQuoteList()
        let quote: QuoteModel = QuoteModel(id: "5cd96e05de30eff6ebcce7e9", _id: "5cd96e05de30eff6ebcce7e9")
        let quotesList = QuoteListModel(docs: [quote])
        
        let character = CharacterModel(_id: "5cd99d4bde30eff6ebccfe9e", name: "Gollum")
        let characterList = CharacterListModel(docs: [character])
        
        mockAPIService.quotesResult = .success(quotesList)
        mockAPIService.charactersResult = .success(characterList)

        // Initialize ViewModel
        viewModel = try! await CharacterListViewModel(movie: makeMovieModel(), apiService: mockAPIService)
        
        viewModel.$characters
            .dropFirst() // Wait for characters to be set
            .sink { characters in
                XCTAssertEqual(characters.count, 1)
                XCTAssertEqual(characters.first?.name, "Gollum")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testFetchQuotes_Failure_ShowsError() async throws {
        let expectation = self.expectation(description: "Error message shown on quote fetch failure")
        
        mockAPIService.quotesResult = .failure(.responseError)
        
        viewModel = try! await CharacterListViewModel(movie: makeMovieModel(), apiService: mockAPIService)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertFalse(errorMessage.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        await fulfillment(of: [expectation], timeout: 50)
    }
    
    func testFetchCharacters_Failure_ShowsError() async throws {
        let expectation = self.expectation(description: "Error message shown on character fetch failure")

        // Quotes succeed, characters fail
        let quoteListModel = try await mockAPIService.getMockQuoteList()
        let quote: QuoteModel = (quoteListModel?.docs.first)!
        let quotesList = QuoteListModel(docs: [quote])
        
        
        mockAPIService.quotesResult = .success(quotesList)
        mockAPIService.charactersResult = .failure(.responseError)

        viewModel = await CharacterListViewModel(movie: try! makeMovieModel(), apiService: mockAPIService)
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertFalse(errorMessage.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 50)
    }

}

