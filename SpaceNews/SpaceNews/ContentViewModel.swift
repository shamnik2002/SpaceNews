//
//  ContentViewModel.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Combine
import Foundation
import UIKit

final class ContentViewModel: ObservableObject {
    private let appStore: AppStore
    let homeViewModel: HomeViewModel
    let savedViewModel: SavedViewModel
    
    init(appStore: AppStore) {
        self.appStore = appStore
        homeViewModel = HomeViewModel(appStore: appStore)
        savedViewModel = SavedViewModel(appStore: appStore)
    }
    
    func saveSavedNewsToDisk() {
        let appStore = self.appStore
        Task {
            await BackgroundTaskManager().runJob(name: "Save Saved News To Disk", appStore: appStore, action: SaveSavedNewsToStore())
        }
    }
}

enum NewsCategory: String {
    case home
    case saved
}
    
actor BackgroundTaskManager {

    @MainActor
    init() {
        self.app = UIApplication.shared
    }
    
    let app: UIApplication
    
    func runJob(name: String, appStore: AppStore, action: ReduxAction) {
        let t = self.app.beginBackgroundTask(withName: name) {
         //   … handle expiration …
        }
        defer {
            if t != .invalid {
                self.app.endBackgroundTask(t)
            }
        }
        Task {
            let action = await SaveSavedNewsToStore()
            await appStore.dispatcher.dispatch(action)
        }
    }
}
