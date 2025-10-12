//
//  SpaceNewsControllerViewModel.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//
import Foundation
import Combine
import UIKit

final class SpaceNewsControllerViewModel: SpaceNewsCollectionViewModelProtocol {

    private var appStore: AppStore
    private var news: [SpaceNewsModel] = []
    private var savedNews =  Set<SpaceNewsModel>()
    private var category: NewsCategory
    private var lastOffset: Int = 0
    private let limit: Int = 10
    private var hasReachedEnd: Bool = false
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
                    self.saveSavedNews(response.1)
                case category:
                    self.updateNewsCache(newsResponse: response.1)
                default:
                    break
                }
            }.store(in: &cancellables)
        
    }
    
    private func fetchSavedNews() {
        let action = GetSavedNews()
        self.appStore.dispatcher.dispatch(action)
    }
    
    func fetchNews() {
        guard !isLoading else { return }
        isLoading = true
        lastOffset = 0
        let action = GetSpaceNews(limit: limit, offset: lastOffset, category: category)
        lastOffset += limit
        self.appStore.dispatcher.dispatch(action)
    }
    
    func fetchMoreNews() {
        guard !isLoading || !hasReachedEnd else { return }
        
        let action = GetSpaceNews(limit: limit, offset: lastOffset, category: category)
        lastOffset += limit
        self.appStore.dispatcher.dispatch(action)
    }
    
    func isSavedNewsItem(_ news: SpaceNewsModel) -> Bool {
        return self.savedNews.contains(news)
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
        hasReachedEnd = newsResponse.next == nil
        if let _ = newsResponse.previous {
            // we need to append
            self.news.append(contentsOf: results)
        } else {
            // we need to replace
            self.news = results
        }
        newsPublisher.send(self.news)
    }
        
    private func saveSavedNews(_ response: SpaceNewsResponse) {
        guard let savedNewsItems = response.results else { return }
        self.savedNews = Set(savedNewsItems)
        newsPublisher.send(self.news)
    }
    
    func showDetailVC(news: SpaceNewsModel, presentingVC: UIViewController) {
        guard let urlString = news.url, let url = URL(string: urlString) else { return }
        let action = OpenInSafari(url: url, presentingVC: presentingVC)
        self.appStore.dispatcher.dispatch(action)
    }
}
