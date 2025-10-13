//
//  SearchView.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/12/25.
//

import SwiftUI
import Combine

struct SearchView: View {
    @StateObject var viewModel: SearchViewModel
    var body: some View {
        NavigationStack {
            SearchResultsCollectionViewControllerRespresentable(appStore: viewModel.appStore, searchTextListener: viewModel.$searchText.eraseToAnyPublisher())
                .edgesIgnoringSafeArea(.all)
        }.navigationTitle("Search")
        .searchable(text: $viewModel.searchText, placement: .automatic)
    }
}

struct SearchResultsCollectionViewControllerRespresentable: UIViewControllerRepresentable {
    private var appStore: AppStore
    private var searchTextListener: AnyPublisher<String, Never>
    init(appStore: AppStore, searchTextListener: AnyPublisher<String, Never>) {
        self.appStore = appStore
        self.searchTextListener = searchTextListener
    }
    
    func makeUIViewController(context: Context) -> SearchResultsViewController {
        let viewModel = SearchResultsViewModel(appStore: appStore, searchTextListener: searchTextListener)
        let vc = SearchResultsViewController(viewModel: viewModel)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: SearchResultsViewController, context: Context) {
        
    }
    typealias UIViewControllerType = SearchResultsViewController
}
