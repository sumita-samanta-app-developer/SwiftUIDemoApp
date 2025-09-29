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

    func test_onAppear_withSuccessfulResponse_updatesMovies() {
        // Given
        let movie = MovieModel(
            _id: "1",
            name: "The Lord of the Rings Series",
            runtimeInMinutes: 148,
            budgetInMillions: 160,
            boxOfficeRevenueInMillions: 829,
            academyAwardNominations: 8,
            academyAwardWins: 4,
            rottenTomatoesScore: 87.0
        )
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

        viewModel.apply(.onAppear)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_onAppear_withResponseError_showsError() {
        // Given
        mockService.movieResult = .failure(.responseError)
        viewModel = MovieListViewModel(apiService: mockService)

        let expectation = XCTestExpectation(description: "Error shown")

        // When
        viewModel.$isErrorShown
            .dropFirst()
            .sink { isShown in
                // Then
                XCTAssertTrue(isShown)
                XCTAssertEqual(self.viewModel.errorMessage, "")
                XCTAssertTrue(self.viewModel.movies.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.apply(.onAppear)

        wait(for: [expectation], timeout: 1.0)
    }

    func test_onAppear_withParseError_showsParseError() {
        // Given
        mockService.movieResult = .failure(.parseError(NSError(domain: "", code: 999, userInfo: nil)))
        viewModel = MovieListViewModel(apiService: mockService)

        let expectation = XCTestExpectation(description: "Parse error shown")

        // When
        viewModel.$errorMessage
            .dropFirst()
            .sink { error in
                // Then
                XCTAssertEqual(error, "parse error")
                XCTAssertTrue(!self.viewModel.isErrorShown)
                XCTAssertTrue(self.viewModel.movies.isEmpty)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.apply(.onAppear)

        wait(for: [expectation], timeout: 1.0)
    }
}
