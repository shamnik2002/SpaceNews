//
//  SavedNewsControllerViewModel.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/12/25.
//
import Foundation
import Combine
import UIKit

final class SavedNewsControllerViewModel: SpaceNewsCollectionViewModelProtocol {
    
    private var appStore: AppStore
    private var news: [SpaceNewsModel] = []
    private var category: NewsCategory
    var cancellables: Set<AnyCancellable> = []
    
    private var isLoading: Bool = false
    private(set) var newsPublisher = PassthroughSubject<[SpaceNewsModel], Never>()
    
    init(appStore: AppStore, category: NewsCategory) {
        self.appStore = appStore
        self.category = category
        self.appStore.appState.spaceNewsResponsePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] response in
                guard let self else {return}
                switch response.0 {
                case .saved:
                    self.updateNewsCache(newsResponse: response.1)
                default:
                    break
                }
            }.store(in: &cancellables)
    }
     
    func fetchNews() {
        guard !isLoading else { return }
        isLoading = true
        let action = GetSavedNews()
        self.appStore.dispatcher.dispatch(action)
    }
    
    func fetchMoreNews() {
    }
    
    func isSavedNewsItem(_ news: SpaceNewsModel) -> Bool {
        return true
    }
    
    func onSave(newsItem: SpaceNewsModel, isSaved: Bool) {
        if isSaved {
            let action = SaveNewsItem(newsItem: newsItem)
            self.appStore.dispatcher.dispatch(action)
        } else {
            let action = DeleteSavedNewsItem(newsItem: newsItem)
            self.appStore.dispatcher.dispatch(action)
        }
    }
    
    private func updateNewsCache(newsResponse: SpaceNewsResponse) {
        defer {
            isLoading = false
        }
        // only do something if we have some valid results
        guard let results = newsResponse.results else {
            return
        }
        self.news = results
        newsPublisher.send(self.news)
    }

    func showDetailVC(news: SpaceNewsModel, presentingVC: UIViewController) {
        guard let urlString = news.url, let url = URL(string: urlString) else { return }
        let action = OpenInSafari(url: url, presentingVC: presentingVC)
        self.appStore.dispatcher.dispatch(action)
    }
}

