//
//  ContentViewModel.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Combine
import Foundation

final class ContentViewModel: ObservableObject {
    private let appStore: AppStore
    let homeViewModel: HomeViewModel
    let savedViewModel: SavedViewModel
    
    init(appStore: AppStore) {
        self.appStore = appStore
        homeViewModel = HomeViewModel(appStore: appStore)
        savedViewModel = SavedViewModel(appStore: appStore)
    }
}

enum NewsCategory: String {
    case home
    case saved
}
    
    
