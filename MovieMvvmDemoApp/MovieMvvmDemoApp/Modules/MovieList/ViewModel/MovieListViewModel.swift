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
    typealias InputType = Input

    private var cancellables: [AnyCancellable] = []
    
    // MARK: Input
    enum Input {
        case onAppear
    }
    func apply(_ input: Input) {
        switch input {
        case .onAppear: onAppearSubject.send(())
        }
    }
    private let onAppearSubject = PassthroughSubject<Void, Never>()
    
    // MARK: Output
    @Published private(set) var movies: [MovieModel] = []
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published private(set) var shouldShowIcon = false
    
    private let responseSubject = PassthroughSubject<MovieListModel, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    // private let trackingSubject = PassthroughSubject<TrackEventType, Never>()
    
    private let apiService: APIServiceType
    // private let trackerService: TrackerType
    // private let experimentService: ExperimentServiceType
    init(apiService: APIServiceType = APIService()) {
        self.apiService = apiService
        //self.trackerService = trackerService
        //self.experimentService = experimentService
        
//        bindInputs()
//        bindOutputs()
        
        fetchMovies()
    }
    
    private func fetchMovies() {
        //isLoading = true
        errorMessage = ""

        apiService.fetchMovies()
            .receive(on: DispatchQueue.main) // Ensure UI updates on main thread
            .sink { [weak self] completion in
               // self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movieList in
                self?.movies = movieList.docs
            }
            .store(in: &cancellables) // Store the subscription
    }
    
    private func bindInputs() {
        let request = MovieRequest()
        let responsePublisher = onAppearSubject
            .flatMap { [apiService] _ in
                apiService.response(from: request)
                    .catch { [weak self] error -> Empty<MovieListModel, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                }
        }
        
        let responseStream = responsePublisher
            .share()
            .subscribe(responseSubject)
        
//        let trackingSubjectStream = trackingSubject
//            .sink(receiveValue: trackerService.log)
//        
//        let trackingStream = onAppearSubject
//            .map { .listView }
//            .subscribe(trackingSubject)
        
        cancellables += [
            responseStream,
//            trackingSubjectStream,
//            trackingStream,
        ]
    }
    
    private func bindOutputs() {
        let repositoriesStream = responseSubject
            .map { $0.docs }
            .assign(to: \.movies, on: self)
        
        let errorMessageStream = errorSubject
            .map { error -> String in
                switch error {
                case .responseError: return "network error"
                case .parseError: return "parse error"
                }
            }
            .assign(to: \.errorMessage, on: self)
        
        let errorStream = errorSubject
            .map { _ in true }
            .assign(to: \.isErrorShown, on: self)
        
//        let showIconStream = onAppearSubject
//            .map { [experimentService] _ in
//                experimentService.experiment(for: .showIcon)
//            }
//            .assign(to: \.shouldShowIcon, on: self)
        
        cancellables += [
            repositoriesStream,
            errorStream,
            errorMessageStream,
//            showIconStream
        ]
    }
}
