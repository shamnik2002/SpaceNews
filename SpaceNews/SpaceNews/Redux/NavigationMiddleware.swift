//
//  NavigationMiddleware.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import Foundation
import Combine
import UIKit
import SafariServices

final class NavigationMiddleware {
    private let dispatch: Dispatch
    private var cancellables: Set<AnyCancellable> = []
    
    init(dispatch: @escaping Dispatch, listner: AnyPublisher<NavigationAction?, Never>) {
        self.dispatch = dispatch
        
        listner.sink {[weak self] action in
            guard let action else { return }
            self?.handle(action: action)
        }.store(in: &cancellables)
    }
    
    private func handle(action: ReduxAction) {
        switch action {
            case let action as OpenInSafari:
                openInSafari(url: action.url, presentingVC: action.presentingVC)
                break
            default:
                break
        }
    }
    
    private func openInSafari(url: URL, presentingVC: UIViewController) {
        let vc = SFSafariViewController(url: url)
        presentingVC.present(vc, animated: true, completion: nil)
    }
}
