//
//  CharacterDetailsView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct CharacterDetailsView: View {
    @ObservedObject var viewModel: CharacterDetailsViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(viewModel.character.name)
            Text("Wiki Url: \(viewModel.character.wikiUrl ?? "")")
            Text("Race: \(viewModel.character.race ?? "")")
            Text("DOB: \(viewModel.character.birth ?? "")")
            Text("Gender: \(viewModel.character.gender ?? "")")
            Text("Death: \(viewModel.character.death ?? "")")
            Text("Hair: \(viewModel.character.hair ?? "")")
            Text("Height: \(viewModel.character.height ?? "")")
            Text("Realm: \(viewModel.character.realm ?? "")")
            Text("Spouse: \(viewModel.character.spouse ?? "")")
            
            Spacer()
        }
        .navigationBarTitle(Text("Character Details"))
    }
}

#if DEBUG
struct CharacterDetailsView_Previews : PreviewProvider {
    static var previews: some View {
        CharacterDetailsView(viewModel: .init(character: CharacterModel(_id: "1", name: ""))
        )
    }
}
#endif
