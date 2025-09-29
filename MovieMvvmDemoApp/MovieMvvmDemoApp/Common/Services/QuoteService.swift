//
//  QuoteService.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation

struct QuoteRequest: APIRequestType {
    typealias Response = QuoteListModel
    
    var path: String { return "/quote" }
}
