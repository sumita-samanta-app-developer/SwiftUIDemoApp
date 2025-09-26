//
//  QuoteListRow.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct QuoteListRow: View {

    @State var quote: QuoteModel

    var body: some View {
        Text(quote.dialog ?? "")
    }
}

#if DEBUG
struct QuoteListRow_Previews : PreviewProvider {
    static var previews: some View {
        QuoteListRow(quote: QuoteModel(id: "1", _id: "1"))
    }
}
#endif
