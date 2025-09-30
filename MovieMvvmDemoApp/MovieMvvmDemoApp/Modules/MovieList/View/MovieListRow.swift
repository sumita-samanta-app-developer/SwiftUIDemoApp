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
    @State var isFavorite: Bool
    @State private var navigate = false

    var body: some View {
        ZStack {
            NavigationLink(destination: CharacterListView(viewModel: CharacterListViewModel(movie: movie)),isActive: $navigate) {
                EmptyView()
            }
            HStack {
                Text(movie.name)
                Spacer()
                Button(action: {
                    isFavorite.toggle()
                    UserDefaults.standard.set(isFavorite, forKey: movie._id)
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()
            }
            .contentShape(Rectangle())
            .onTapGesture {
                navigate = true
            }
        }
    }
}

#if DEBUG
struct MovieListRow_Previews : PreviewProvider {
    static var previews: some View {
        MovieListRow(movie: MovieModel(_id: "1", name: "", runtimeInMinutes: 0, budgetInMillions: 0, boxOfficeRevenueInMillions: 0, academyAwardNominations: 0, academyAwardWins: 0, rottenTomatoesScore: 0), isFavorite: false)
    }
}
#endif
