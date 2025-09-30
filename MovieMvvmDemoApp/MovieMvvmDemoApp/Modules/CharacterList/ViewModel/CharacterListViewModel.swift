//
//  CharacterListViewModel.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI
import Combine

final class CharacterListViewModel: ObservableObject {
    
    private var cancellables: [AnyCancellable] = []
    
    // MARK: Output
    @Published private(set) var characters: [CharacterModel] = []
    @Published private(set) var quotes: [QuoteModel] = []
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    @Published var showQuote = false
    
    private var apiService: APIServiceType
    let movie: MovieModel
    
    init(movie: MovieModel, apiService: APIServiceType = APIService()) {
        self.movie = movie
        self.apiService = apiService
        
        // Read from Info.plist
        showQuote = Bundle.main.object(forInfoDictionaryKey: "ShowQuote") as? Bool ?? false
        
        self.fetchQuotes()
    }
    
    // Fetch Quotes
    private func fetchQuotes() {
        let request = QuoteRequest()
        apiService.response(from: request)
        .receive(on: DispatchQueue.main) // Ensure UI updates on main thread
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.isErrorShown = true
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] movieList in
            self?.quotes = movieList.docs.filter({ $0.movie == self?.movie._id })
            self?.fetchCharacters()
        }
        .store(in: &cancellables)
    }
    
    // Fetch characters
    private func fetchCharacters() {
        let request = CharacterRequest()
        apiService.response(from: request)
        .receive(on: DispatchQueue.main) // Ensure UI updates on main thread
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.isErrorShown = true
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] movieList in
            let filteredQuotes: [String] = self!.filterQuotesByMovieId()
            self?.characters = movieList.docs.filter({ filteredQuotes.contains($0._id) })
        }
        .store(in: &cancellables)
    }
    
    func filterQuotesByMovieId() -> [String] {
        // Fetch quote ids to filter character list
        var quoteId: [String] = []
        for quote in self.quotes {
            if (quote.movie == self.movie._id) {
                quoteId.append(quote.character ?? "")
            }
        }
        return quoteId
    }
}
