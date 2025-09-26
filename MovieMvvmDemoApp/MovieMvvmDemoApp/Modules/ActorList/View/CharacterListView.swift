//
//  CharacterListView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import SwiftUI

struct CharacterListView : View {
    @ObservedObject var viewModel: CharacterListViewModel
    
    var body: some View {
        
        List(viewModel.characters) { Character in
            CharacterListRow(character: Character)
        }
        .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        })
        .navigationBarTitle(Text("Characters"))

        .onAppear(perform: { self.viewModel.apply(.onAppear) })
    }
}

#if DEBUG
struct CharacterListView_Previews : PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: .init())
    }
}
#endif
