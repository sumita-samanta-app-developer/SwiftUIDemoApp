//
//  CharacterDetailsView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct CharacterDetailsView: View {
    @StateObject var viewModel: CharacterDetailsViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Name: \(viewModel.character.name)").padding(.all, 8)
            Text("Wiki Url: \(viewModel.character.wikiUrl ?? "")").padding(.all, 8)
            Text("Race: \(viewModel.character.race ?? "")").padding(.all, 8)
            Text("DOB: \(viewModel.character.birth ?? "")").padding(.all, 8)
            Text("Gender: \(viewModel.character.gender ?? "")").padding(.all, 8)
            Text("Death: \(viewModel.character.death ?? "")").padding(.all, 8)
            Text("Hair: \(viewModel.character.hair ?? "")").padding(.all, 8)
            Text("Height: \(viewModel.character.height ?? "")").padding(.all, 8)
            Text("Realm: \(viewModel.character.realm ?? "")").padding(.all, 8)
            Text("Spouse: \(viewModel.character.spouse ?? "")").padding(.all, 8)
            
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
