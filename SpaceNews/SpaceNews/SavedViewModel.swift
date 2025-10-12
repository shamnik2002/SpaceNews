//
//  SavedViewModel.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//
import SwiftUI
import Combine

final class SavedViewModel: ObservableObject {
    @Published var news: [SpaceNewsModel] = []
    let appStore: AppStore
    var cancellables = Set<AnyCancellable>()
    
    init(appStore: AppStore) {
        self.appStore = appStore
        self.appStore.appState.spaceNewsResponsePublisher
            .receive(on: RunLoop.main)
            .sink {[weak self] result in
                guard result.0 == NewsCategory.saved else {return}
                guard let newsItems = result.1.results else { return }
                self?.news = newsItems
            }.store(in: &cancellables)
    }
    
    func fetchNews() {
        let getNewsAction = GetSpaceNews(category: NewsCategory.saved)
        self.appStore.dispatcher.dispatch(getNewsAction)
    }
}
