//
//  CharacterListView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import SwiftUI

struct CharacterListView : View {
    @ObservedObject var viewModel: CharacterListViewModel
    // To show/hide ShowQuote option
    let showQuote: Bool
    // To retrieve the value from info.plist
    init(viewModel: CharacterListViewModel) {
        // Retrieve the Boolean value from Info.plist
        if let infoDict = Bundle.main.infoDictionary,
           let showFeature = infoDict["ShowQuote"] as? Bool {
            self.showQuote = showFeature
        } else {
            // Provide a default value if the key is not found or not a Bool
            self.showQuote = false
        }
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack (alignment: .trailing) {
            if showQuote {
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
            List(viewModel.characters) { Character in
                CharacterListRow(character: Character)
            }
            
            Spacer()
        }
        .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        })
            .navigationBarTitle(Text("Characters")) // Optional: Set a title for the navigation bar
        .onAppear(perform: { self.viewModel.apply(.onAppear) })
    }
}

#if DEBUG
struct CharacterListView_Previews : PreviewProvider {
    static var previews: some View {
        CharacterListView(viewModel: CharacterListViewModel(movie: MovieModel(_id: "1", name: "")))
    }
}
#endif
