//
//  SpaceNewsApp.swift
//  SpaceNews
//
//  Created by Shamal nikam on 10/11/25.
//

import SwiftUI

@main
struct SpaceNewsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(appStore: AppStore()))
        }
    }
}
