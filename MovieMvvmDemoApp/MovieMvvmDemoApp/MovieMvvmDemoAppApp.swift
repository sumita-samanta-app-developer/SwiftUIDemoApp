//
//  MovieMvvmDemoAppApp.swift
//  MovieMvvmDemoApp
//
//  Created by Koustav Sen on 24/09/25.
//

import SwiftUI

@main
struct MovieMvvmDemoAppApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: .init())
        }
    }
}
