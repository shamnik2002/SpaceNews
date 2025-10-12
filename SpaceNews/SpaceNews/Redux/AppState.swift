//
//  AppState.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import Combine

final class AppState {
    
    private let dispatch: Dispatch
    
    private(set) var spaceNewsResponsePublisher = PassthroughSubject<(NewsCategory, SpaceNewsResponse), Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(dispatch: @escaping Dispatch, listner: AnyPublisher<SetNewsAction?, Never>) {
        self.dispatch = dispatch
        listner.sink {[weak self] action in
            guard let action else {return}
            self?.handle(action)
        }.store(in: &cancellables)
            
    }
    
    func handle(_ action: ReduxAction?) {
        switch action {
        case let action as SetSpaceNews:
            spaceNewsResponsePublisher.send((action.category, action.news))
            break
        case let action as SetSavedNews:
            spaceNewsResponsePublisher.send((action.category, action.news))
        default:
            break
        }
    }
    
}
