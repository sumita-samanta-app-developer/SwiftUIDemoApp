//
//  MovieListModel.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct MovieModel: Decodable, Hashable, Identifiable {
    let id = UUID()
    var _id: String
    var name: String
    var runtimeInMinutes: Double?
    var budgetInMillions: Double?
    var boxOfficeRevenueInMillions: Double?
    var academyAwardNominations: Double?
    var academyAwardWins: Double?
    var rottenTomatoesScore: Double?
}

struct MovieListModel: Decodable {
    var docs: [MovieModel]
}
