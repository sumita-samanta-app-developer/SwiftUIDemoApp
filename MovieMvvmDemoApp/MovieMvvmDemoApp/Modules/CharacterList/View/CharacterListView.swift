//
//  CharacterListView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import SwiftUI

struct CharacterListView : View {
    @StateObject var viewModel: CharacterListViewModel
    
    var body: some View {
        VStack (alignment: .trailing) {
            if viewModel.showQuote {
                ShowQuoteView(viewModel: viewModel)
            }
            List(viewModel.characters.sorted(by: { $0.name < $1.name })) { Character in
                CharacterListRow(character: Character)
            }
            
            Spacer()
        }
        .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        })
        .navigationBarTitle(Text("Characters")) // Optional: Set a title for the navigation bar
    }
}

struct ShowQuoteView: View {
    let viewModel: CharacterListViewModel
    
    var body: some View {
        NavigationLink {
            QuoteListView(viewModel: QuoteListViewModel(quoteList: viewModel.quotes)) // The destination view
        } label: {
            Text("Show Quotes")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

#if DEBUG
struct CharacterListView_Previews : PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: CharacterListViewModel(movie: MovieModel(_id: "1", name: "")))
    }
}
#endif
