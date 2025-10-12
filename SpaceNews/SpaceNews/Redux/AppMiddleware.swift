//
//  AppMiddleware.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import Combine

final class AppMiddleware {
    private let dispatch: Dispatch
    private let networkService: NetworkProtocol
    private let parser: ParseProtocol
    private let newsStore: NewsStore
    private let newsCache: NewsCache
    private var cancellables: Set<AnyCancellable> = []
    
    private var fetchedFromStore: [String: Bool] = [:]
    
    init(dispatch: @escaping Dispatch, networkService: NetworkProtocol, parser: ParseProtocol, newsStore: NewsStore, newsCache: NewsCache, listner: AnyPublisher<NewsAction?, Never>) {
        self.dispatch = dispatch
        self.networkService = networkService
        self.parser = parser
        self.newsStore = newsStore
        self.newsCache = newsCache
        listner.sink {[weak self] action in
            guard let action else {return}
            self?.handle(action)
        }.store(in: &cancellables)
    }
    
    private func handle(_ action: ReduxAction?) {
        switch action {
        case let action as GetSpaceNews:
            fetchNews(limit: action.limit, offset: action.offset, category: action.category)
            break
        case let action as SavedNewsAction:
            handleSavedNewsAction(action)
            break
        default:
            break
        }
    }
    
    private func handleSavedNewsAction( _ action: SavedNewsAction) {
        switch action {
            case let action as GetSavedNews:
                getSavedNews(category: action.category)
            case let action as SaveNewsItem:
                saveNewsItem(action.newsItem, category: action.category)
                break
            case let action as DeleteSavedNewsItem:
                deleteSavedNewsItem(action.newsItem, category: action.category)
                break
            case let action as SaveSavedNewsToStore:
                saveSavedNewsToStore(action.news, category: action.category)
                break
            default:
                break
        }
    }
    
    private func getSavedNews(category: NewsCategory) {
        Task {[weak self] in
            let news = await self?.getFromCache(category: category.rawValue)
            if let news, !news.isEmpty {
                let response = SpaceNewsResponse(count: news.count, next: nil, previous: nil, results: news)
                let action = SetSavedNews(news: response)
                self?.dispatch(action)
            }
        }        
    }
    
    private func saveNewsItem(_ newsItem: SpaceNewsModel, category: NewsCategory) {
        Task {[weak self] in
            var news = await self?.getFromCache(category: category.rawValue)
            news?.append(newsItem)
            if let news, !news.isEmpty {
                await self?.newsCache.saveNews(news, category: category.rawValue)
                let response = SpaceNewsResponse(count: news.count, next: nil, previous: nil, results: news)
                let action = SetSavedNews(news: response)
                self?.dispatch(action)
            }
        }
    }
    
    private func deleteSavedNewsItem(_ newsItem: SpaceNewsModel, category: NewsCategory) {
        Task {[weak self] in
            var news = await self?.getFromCache(category: category.rawValue)
            news?.removeAll { item in
                item.id == newsItem.id
            }
            await self?.newsCache.saveNews(news ?? [], category: category.rawValue)
            let response = SpaceNewsResponse(count: news?.count ?? 0, next: nil, previous: nil, results: news)
            let action = SetSavedNews(news: response)
            self?.dispatch(action)
        }
    }
    
    private func saveSavedNewsToStore(_ news: [SpaceNewsModel], category: NewsCategory) {
        Task {[weak self] in
            try? await self?.newsStore.saveToStore(news: news, category:category.rawValue)
        }
    }
    
    // All news except saved category which we fetch from remote
    private func fetchNews(limit: Int, offset: Int, category: NewsCategory) {
        let request = SpaceNewsRequest(limit: limit, offset: offset)
        let parser = parser
        networkService.fetchDataWithPublisher(request: request)
            .flatMap{ data in
                return parser.parse(data: data, type: SpaceNewsResponse.self).eraseToAnyPublisher()
            }.sink { completion in
               
            } receiveValue: {[weak self] response in
                let action = SetSpaceNews(news: response, category: category)
                self?.dispatch(action)
                if offset == 0 { // we only save the first page
                    self?.save(news: response, category: category.rawValue)
                }
            }.store(in: &cancellables)
        
        Task {[weak self] in
            if offset == 0 { // we only save the first page
                let news = await self?.getFromCache(category: category.rawValue)
                if let news, !news.isEmpty {
                    let response = SpaceNewsResponse(count: news.count, next: nil, previous: nil, results: news)
                    let action = SetSpaceNews(news: response, category: category)
                    self?.dispatch(action)
                }
            }
        }        
    }
    
    private func getFromCache(category: String) async -> [SpaceNewsModel]? {
        var news = await newsCache.getNews(category: category)
        let attemptedToFetchFromStore = fetchedFromStore[category] ?? false
        guard let newsItems = news, !newsItems.isEmpty, attemptedToFetchFromStore else {
            fetchedFromStore[category] = true
            news = await getFromStore(category: category)
            if let news {
                await newsCache.saveNews(news, category: category)
                return news
            }
            return []
        }
        return news
    }
    
    private func getFromStore(category: String) async -> [SpaceNewsModel]? {
        return try? await newsStore.getFromStore(category: category)
    }
    
    private func save(news: SpaceNewsResponse, category: String) {
        guard let newsItems = news.results else {return}
        Task {
            await newsCache.saveNews(newsItems, category: category)
            do {
                try await newsStore.saveToStore(news: newsItems, category: category)
            } catch {
                // log error
            }
        }
    }
}
