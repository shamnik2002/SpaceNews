//
//  Dispacther.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import Combine

typealias Dispatch = (ReduxAction) -> Void

final class Dispatcher {
    
    @Published var newsAction: NewsAction?
    @Published var setNewsAction: SetNewsAction?
    @Published var navigationAction: NavigationAction?
    
    func dispatch(_ action: ReduxAction) {
        switch action {
            case let action as NewsAction:
                newsAction = action
            case let action as SetNewsAction:
                setNewsAction = action
            case let action as NavigationAction:
                navigationAction = action
            default:
                break
        }
    }
}
