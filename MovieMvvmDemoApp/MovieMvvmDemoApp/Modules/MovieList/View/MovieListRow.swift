//
//  MovieListRow.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import Foundation
import SwiftUI

struct MovieListRow: View {

    @State var movie: MovieModel

    var body: some View {
        NavigationLink(destination: CharacterListView(viewModel: .init())) {
            Text(movie.name)
        }
    }
}

#if DEBUG
struct MovieListRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieListRow(movie: MovieModel(_id: "1", name: "", runtimeInMinutes: 0, budgetInMillions: 0, boxOfficeRevenueInMillions: 0, academyAwardNominations: 0, academyAwardWins: 0, rottenTomatoesScore: 0))
    }
}
#endif
