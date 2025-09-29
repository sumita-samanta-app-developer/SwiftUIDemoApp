//
//  MovieListViewModel.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI
import Combine

final class MovieListViewModel: ObservableObject {
    private var cancellables: [AnyCancellable] = []
    
    // MARK: Output
    @Published private(set) var movies: [MovieModel] = []
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    
    private let responseSubject = PassthroughSubject<MovieListModel, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private let apiService: APIServiceType
    
    init(apiService: APIServiceType = APIService(baseURL: URL(string: "\(AppConstants.BASEURL)\(APIEndpoint.movies)")!)) {
        self.apiService = apiService
        
        fetchMovies()
    }
    
    // To fetch List of movies
    private func fetchMovies() {
        let request = MovieRequest()
        apiService.response(from: request)
        .receive(on: DispatchQueue.main) // Ensure UI updates on main thread
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] movieList in
            self?.movies = movieList.docs
        }
        .store(in: &cancellables)
    }
}
