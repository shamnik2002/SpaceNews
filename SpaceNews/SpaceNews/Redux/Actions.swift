//
//  Actions.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import UIKit

protocol ReduxAction {}

protocol ReduxMutatingAction: ReduxAction {}


protocol NewsAction: ReduxAction {}
protocol SetNewsAction: ReduxMutatingAction {}

// Home fetch/set news
struct GetSpaceNews: NewsAction {
    let limit: Int
    let offset: Int
    let category: NewsCategory
    
    init(limit: Int = 10, offset: Int = 0, category: NewsCategory) {
        self.limit = limit
        self.offset = offset
        self.category = category
    }
}

struct SetSpaceNews: SetNewsAction {
    let news: SpaceNewsResponse
    let category: NewsCategory
}

// Saved fetch/save actions
struct SetSavedNews: SetNewsAction {
    let news: SpaceNewsResponse
    let category: NewsCategory = .saved
}
protocol SavedNewsAction: NewsAction {}

struct GetSavedNews: SavedNewsAction {
    let category: NewsCategory = .saved
}

struct SaveNewsItem: SavedNewsAction {
    let newsItem: SpaceNewsModel
    let category: NewsCategory = .saved
}

struct DeleteSavedNewsItem: SavedNewsAction {
    let newsItem: SpaceNewsModel
    let category: NewsCategory = .saved
}

struct SaveSavedNewsToStore: SavedNewsAction {
    let category: NewsCategory = .saved
}

// Search actions
struct SearchNews: NewsAction {
    let query: String
    let limit: Int
    let offset: Int
    
    init(query: String, limit: Int = 10, offset: Int = 0) {
        self.query = query
        self.limit = limit
        self.offset = offset
    }
}

struct SetSearchNews: SetNewsAction {
    let news: SpaceNewsResponse
}

// Navigation actions
protocol NavigationAction: ReduxAction {
    
}

struct OpenInSafari: NavigationAction {
    let url: URL
    let presentingVC: UIViewController
}
