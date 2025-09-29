//
//  MovieListViewModelTest.swift
//  MovieMvvmDemoAppTests
//
//  Created by Sumita Samanta on 29/09/25.
//

import XCTest
import Combine
@testable import MovieMvvmDemoApp

final class MovieListViewModelTests: XCTestCase {
    var viewModel: MovieListViewModel!
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

    func test_onAppear_withSuccessfulResponse_updatesMovies() async throws {
        // Given
        let movieListModel = try await mockService.getMockMovieList()
        let movie: MovieModel = (movieListModel?.docs.first)!
        
        mockService.movieResult = .success(MovieListModel(docs: [movie]))
        viewModel = MovieListViewModel(apiService: mockService)

        let expectation = XCTestExpectation(description: "Movies loaded")
        
        // When
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                // Then
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.name, "The Lord of the Rings Series")
                XCTAssertFalse(self.viewModel.isErrorShown)
                XCTAssertEqual(self.viewModel.errorMessage, "")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        await fulfillment(of: [expectation], timeout: 50)
    }
    
    func testFetchMoviesFailure() {
        // Arrange
        mockService.movieResult = .failure(.responseError)
        
        let viewModel = MovieListViewModel(apiService: mockService)
        let expectation = XCTestExpectation(description: "Error received")
        
        // Act
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                // Assert
                XCTAssertFalse(errorMessage.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
