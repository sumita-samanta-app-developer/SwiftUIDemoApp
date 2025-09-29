//
//  QuoteListView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import SwiftUI

struct QuoteListView : View {
    @StateObject var viewModel: QuoteListViewModel
    
    var body: some View {
        List(viewModel.quoteList) { quote in
            QuoteListRow(quote: quote)
        }
        .navigationBarTitle(Text("Quotes"))
    }
}

#if DEBUG
struct QuoteListView_Previews : PreviewProvider {
    static var previews: some View {
        QuoteListView(viewModel: .init(quoteList: []))
    }
}
#endif
