//
//  QuoteListModel.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct QuoteModel: Decodable, Hashable, Identifiable {
    var id: String
    var dialog: String?
    var movie: String?
    var character: String?
    var _id: String
}

struct QuoteListModel: Decodable {
    var docs: [QuoteModel]
}
