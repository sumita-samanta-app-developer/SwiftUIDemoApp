//
//  QuoteService.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation

struct QuoteRequest: APIRequestType {
    typealias Response = QuoteListModel
    
    var url: URL { return URL(string: "\(AppConstants.BASEURL)\(APIEndpoint.quote)")! }
}
