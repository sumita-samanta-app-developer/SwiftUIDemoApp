//
//  CharacterService.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation

struct CharacterRequest: APIRequestType {
    typealias Response = CharacterListModel
    
    var url: URL { return URL(string: "\(AppConstants.BASEURL)\(APIEndpoint.character)")! }
}
