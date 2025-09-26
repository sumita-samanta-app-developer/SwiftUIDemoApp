//
//  CharacterDetailsViewModel.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI
import Combine

final class CharacterDetailsViewModel: ObservableObject {
    let character: CharacterModel
    
    init(character: CharacterModel) {
        self.character = character
    }
}
