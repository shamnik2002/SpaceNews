//
//  AppStore.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import Combine

final class AppStore {
    
    static let shared = AppStore()
    let appState: AppState
    let appMidlleware: AppMiddleware
    let navigationMiddleware: NavigationMiddleware
    let dispatcher: Dispatcher
    
    init() {
        self.dispatcher = Dispatcher()

        self.appState = AppState(dispatch: dispatcher.dispatch(_:), listner: dispatcher.$setNewsAction.eraseToAnyPublisher())
        let networkService = NetworkService()
        let parser = Parser()
        let newsCache = NewsCache(cachePolicy: CachePolicy())
        let newsStore = NewsStore()
        self.appMidlleware = AppMiddleware(dispatch: dispatcher.dispatch(_:),
                                           networkService: networkService,
                                           parser: parser,
                                           newsStore: newsStore,
                                           newsCache: newsCache,
                                           listner: dispatcher.$newsAction.eraseToAnyPublisher())
        self.navigationMiddleware = NavigationMiddleware(dispatch: dispatcher.dispatch(_:), listner: dispatcher.$navigationAction.eraseToAnyPublisher())
    }
}


