//
//  MovieListView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import SwiftUI

struct MovieListView : View {
    @StateObject var viewModel: MovieListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.movies.sorted(by: { $0.name < $1.name })) { movie in
                MovieListRow(movie: movie, isFavorite: UserDefaults.standard.bool(forKey: movie._id))
            }
            .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
            })
            .navigationBarTitle(Text("Movies"))
        }
    }
}

#if DEBUG
struct MovieListView_Previews : PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: MovieListViewModel())
    }
}
#endif
