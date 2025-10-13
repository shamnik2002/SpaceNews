//
//  SearchViewModel.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/12/25.
//
import Foundation
import Combine
import SwiftUI

final class SearchViewModel: ObservableObject {
    var appStore: AppStore
    @Published var searchText: String = ""
    init(appStore: AppStore) {
        self.appStore = appStore
    }
}

final class SearchResultsViewModel: SpaceNewsCollectionViewModelProtocol {
    
    private(set) var newsPublisher = PassthroughSubject<[SpaceNewsModel], Never>()
    private var searchResults: [SpaceNewsModel] = []
    private var appStore: AppStore
    private var cancellables = Set<AnyCancellable>()
    private var lastSearchText: String = ""
    init (appStore: AppStore, searchTextListener: AnyPublisher<String, Never>) {
        self.appStore = appStore
        searchTextListener
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink {[weak self] text in
                guard let lastSearchText = self?.lastSearchText, lastSearchText != text else { return }
                self?.fetchSearchResults(text)
                self?.lastSearchText = text
            }.store(in: &cancellables)
        
        appStore.appState.searchResultsPublisher
            .sink {[weak self] response in
                guard let results = response.results else { return }
                self?.processSearchResults(results)
            }.store(in: &cancellables)
    }
    
    func processSearchResults(_ results: [SpaceNewsModel]) {
        self.searchResults = results
        self.newsPublisher.send(results)
    }
    func fetchSearchResults(_ text: String) {
        guard text.count > 2 else {
            // reset to empty
            if !self.searchResults.isEmpty {
                self.searchResults = []
                let response = SpaceNewsResponse(count: 0, next: nil, previous: nil, results: [])
                let action = SetSearchNews(news: response)
                self.appStore.dispatcher.dispatch(action)
            }
            return
        }
        let action = SearchNews(query: text)
        self.appStore.dispatcher.dispatch(action)
    }
    
    func fetchNews() {
        // do nothing
    }
    
    func fetchMoreNews() {
        // do nothing
    }
    
    func isSavedNewsItem(_ news: SpaceNewsModel) -> Bool {
        // check if item is in saved list
        return false
    }
    
    func onSave(newsItem: SpaceNewsModel, isSaved: Bool) {
        // handle save action here
    }
    
    func showDetailVC(news: SpaceNewsModel, presentingVC: UIViewController) {
        guard let urlString = news.url, let url = URL(string: urlString) else { return }
        let action = OpenInSafari(url: url, presentingVC: presentingVC)
        self.appStore.dispatcher.dispatch(action)
    }    
}
