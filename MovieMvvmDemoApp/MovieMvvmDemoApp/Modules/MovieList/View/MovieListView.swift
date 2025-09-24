//
//  MovieListView.swift
//  MovieMvvmDemoApp
//
//  Created by Koustav Sen on 25/09/25.
//

import SwiftUI

struct MovieListView : View {
    @ObservedObject var viewModel: MovieListViewModel
    
    var body: some View {
        NavigationView {
            List(viewModel.movies) { movie in
                MovieListRow(movie: movie)
            }
            .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
            })
            .navigationBarTitle(Text("Movies"))
        }
        .onAppear(perform: { self.viewModel.apply(.onAppear) })
    }
}

#if DEBUG
struct RepositoryListView_Previews : PreviewProvider {
    static var previews: some View {
        MovieListView(viewModel: .init())
    }
}
#endif
