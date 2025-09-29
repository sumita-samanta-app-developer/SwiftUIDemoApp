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
    @Published private(set) var characters: [CharacterModel] = []
    @Published private(set) var quotes: [QuoteModel] = []
    @Published var isErrorShown = false
    @Published var errorMessage = ""
    
    private let characterResponseSubject = PassthroughSubject<CharacterListModel, Never>()
    private let quoteResponseSubject = PassthroughSubject<QuoteListModel, Never>()
    private let errorSubject = PassthroughSubject<APIServiceError, Never>()
    
    private var apiService: APIServiceType
    let movie: MovieModel
    
    init(movie: MovieModel, apiService: APIServiceType = APIService(baseURL: URL(string: "https://e21a086a-4f08-425a-b99c-a9bbe7539a40.mock.pstmn.io/v2/quote")!)) {
        
        self.movie = movie
        self.apiService = apiService
        
        fetchQuotes()
    }
    
    private func fetchQuotes() {
        //isLoading = true
        errorMessage = ""

        apiService.fetchQuotes()
            .flatMap { quotes in // Use flatMap to chain the next API call
                self.quotes = quotes.docs.filter({ $0.movie == self.movie._id })
                return self.apiService.fetchCharacters() // Second API call using the fetched user's ID
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                case .finished:
                    print("All API calls completed successfully.")
                }
            }, receiveValue: { characters in
                print("Fetched characters:")
                let filteredQuotes: [String] = self.filterQuotesByMovieId()
                self.characters = characters.docs.filter({ filteredQuotes.contains($0._id) })
            })
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
