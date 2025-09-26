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
//    let movie: MovieModel
    
    init(/*movie: MovieModel,*/ apiService: APIServiceType = APIService(baseURL: URL(string: "https://e21a086a-4f08-425a-b99c-a9bbe7539a40.mock.pstmn.io/v2/quote")!)) {
        
//        self.movie = movie
        self.apiService = apiService
        
        fetchQuotes()
        fetchCharacters()
        filterCharacters()
        
//        bindInputs()
//        bindOutputs(movieId: "5cd95395de30eff6ebccde5b")
    }
    
    private func fetchQuotes() {
        let quotesRequest = QuoteRequest()
        let quoteResponsePublisher = onAppearSubject
            .flatMap { [apiService] _ in
                apiService.response(from: quotesRequest)
                    .catch { [weak self] error -> Empty<QuoteListModel, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                }
        }
        
        let quoteResponseStream = quoteResponsePublisher
            .share()
            .subscribe(quoteResponseSubject)
        
        cancellables += [
            quoteResponseStream,
        ]
        
        let quoteRepositoriesStream = quoteResponseSubject
            .map { docs in // Map the decoded array
                docs.filter { $0.docs.movie > "5cd95395de30eff6ebccde5b" } }
            .assign(to: \.quotes, on: self)
        
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
        
        cancellables += [
            quoteRepositoriesStream,
            errorStream,
            errorMessageStream,
        ]
        print("Quotes:: \(quotes)")
    }
    
    private func fetchCharacters() {
        apiService = APIService(baseURL: URL(string: "https://e21a086a-4f08-425a-b99c-a9bbe7539a40.mock.pstmn.io/v2/character")!)
        let characterRequest = CharacterRequest()
        let characterResponsePublisher = onAppearSubject
            .flatMap { [apiService] _ in
                apiService.response(from: characterRequest)
                    .catch { [weak self] error -> Empty<CharacterListModel, Never> in
                        self?.errorSubject.send(error)
                        return .init()
                }
        }
        
        let responseStream = characterResponsePublisher
            .share()
            .subscribe(characterResponseSubject)
        
        cancellables += [
            responseStream,
        ]
        
        let characterRepositoriesStream = characterResponseSubject
            .map { $0.docs }
            .assign(to: \.characters, on: self)
        
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
        
        cancellables += [
            characterRepositoriesStream,
            errorStream,
            errorMessageStream,
        ]
        
        print("Char:: \(characters)")
    }
    
    private func filterCharacters() {
        // Fetch quote ids to filter character list
        var filteredQuotes: [QuoteModel] = []
        var quoteId: [String] = []
        for quote in self.quotes {
            if (quote.movie == "5cd95395de30eff6ebccde5b") {
                filteredQuotes.append(quote)
                quoteId.append(quote.character ?? "")
            }
        }
        quotes = filteredQuotes;
        characters = characters.filter { quoteId.contains($0._id) }
        print(characters)
    }
    
    private func bindOutputs(movieId: String) {
        // Bind Quote Response
        let quoteRepositoriesStream = quoteResponseSubject
            .map { $0.docs }
            .assign(to: \.quotes, on: self)
        
        // Fetch quote ids to filter character list
        var filteredQuotes: [QuoteModel] = []
        var quoteId: [String] = []
        for quote in self.quotes {
            if (quote.movie == movieId) {
                filteredQuotes.append(quote)
                quoteId.append(quote.character ?? "")
            }
        }
        quotes = filteredQuotes;
        
        // Bind Character Response
        let characterRepositoriesStream = characterResponseSubject
            .map { $0.docs.filter { quoteId.contains($0._id) } }
            .assign(to: \.characters, on: self)
        
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
        
        cancellables += [
            quoteRepositoriesStream,
            characterRepositoriesStream,
            errorStream,
            errorMessageStream,
        ]
    }
}
