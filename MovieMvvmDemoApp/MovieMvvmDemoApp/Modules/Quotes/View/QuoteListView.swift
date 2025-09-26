//
//  QuoteListView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import SwiftUI

struct QuoteListView : View {
    @ObservedObject var viewModel: QuoteListViewModel
    
    var body: some View {
        
        List(viewModel.quotes) { quote in
            QuoteListRow(quote: quote)
        }
        .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
        })
        .navigationBarTitle(Text("Characters"))

        .onAppear(perform: { self.viewModel.apply(.onAppear) })
    }
}

#if DEBUG
struct QuoteListView_Previews : PreviewProvider {
    static var previews: some View {
        QuoteListView(viewModel: .init())
    }
}
#endif
