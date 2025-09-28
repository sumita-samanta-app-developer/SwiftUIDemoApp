//
//  QuoteListViewModel.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI
import Combine

final class QuoteListViewModel: ObservableObject {
    let quoteList: [QuoteModel]
    
    init(quoteList: [QuoteModel]) {
        self.quoteList = quoteList
    }
}
