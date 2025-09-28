//
//  CharacterListRow.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct CharacterListRow: View {

    @State var character: CharacterModel

    var body: some View {
        NavigationLink(destination: CharacterDetailsView(viewModel: CharacterDetailsViewModel(character: character) )) {
            Text(character.name)
        }
    }
}

#if DEBUG
struct CharacterListRow_Previews : PreviewProvider {
    static var previews: some View {
        CharacterListRow(character: CharacterModel(_id: "1", name: ""))
    }
}
#endif
