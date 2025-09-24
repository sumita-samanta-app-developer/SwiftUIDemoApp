//
//  ActorListView.swift
//  MovieMvvmDemoApp
//
//  Created by Sumita Samanta on 25/09/25.
//

import SwiftUI
//
//struct ActorListView : View {
//    @ObservedObject var viewModel: RepositoryListViewModel
//    
//    var body: some View {
//        NavigationView {
//            List(viewModel.repositories) { repository in
//                RepositoryListRow(repository: repository)
//            }
//            .alert(isPresented: $viewModel.isErrorShown, content: { () -> Alert in
//                Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
//            })
//            .navigationBarTitle(Text("Repositories"))
//        }
//        .onAppear(perform: { self.viewModel.apply(.onAppear) })
//    }
//}
//
//#if DEBUG
//struct ActorListView_Previews : PreviewProvider {
//    static var previews: some View {
//        ActorListView(viewModel: .init())
//    }
//}
//#endif
