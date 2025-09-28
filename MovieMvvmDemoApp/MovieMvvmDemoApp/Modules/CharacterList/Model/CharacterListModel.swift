//
//  CharacterListModel.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct CharacterModel: Decodable, Hashable, Identifiable {
    let id = UUID()
    var _id: String
    var name: String
    var wikiUrl: String?
    var race: String?
    var birth: String?
    var gender: String?
    var death: String?
    var hair: String?
    var height: String?
    var realm: String?
    var spouse: String?
}

struct CharacterListModel: Decodable {
    var docs: [CharacterModel]
}
